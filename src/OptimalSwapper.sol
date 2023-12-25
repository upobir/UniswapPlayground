//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "v2-periphery/interfaces/IUniswapV2Router02.sol";
import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract OptimalSwapper {
    address public immutable token1;
    address public immutable token2;
    address public immutable token3;
    IUniswapV2Router02 public immutable router;

    struct Cycle {
        address first;
        address second;
        address third;
    }

    constructor(
        address _token1,
        address _token2,
        address _token3,
        address _routerAddress
    ) {
        token1 = _token1;
        token2 = _token2;
        token3 = _token3;
        router = IUniswapV2Router02(_routerAddress);
    }

    function getOptimalInitalPath(
        uint256 amountIn,
        address tokenFrom,
        address tokenTo,
        address thirdToken
    ) internal view returns (address[] memory, uint256, Cycle memory) {
        Cycle memory cycle = Cycle({
            first: tokenTo,
            second: tokenTo,
            third: tokenTo
        });
        address[] memory optimalPath;
        uint256 optimalAmountOut;

        address[] memory shortPath = new address[](2);
        shortPath[0] = tokenFrom;
        shortPath[1] = tokenTo;

        address[] memory longPath = new address[](3);
        longPath[0] = tokenFrom;
        longPath[1] = thirdToken;
        longPath[2] = tokenTo;

        uint shortPathAmountOut = router.getAmountsOut(amountIn, shortPath)[1];
        uint longPathAmountOut = router.getAmountsOut(amountIn, longPath)[2];

        if (longPathAmountOut > shortPathAmountOut) {
            optimalPath = longPath;
            cycle.first = tokenFrom;
            cycle.second = thirdToken;
            optimalAmountOut = longPathAmountOut;
        } else {
            optimalPath = shortPath;
            cycle.first = thirdToken;
            cycle.second = tokenFrom;
            optimalAmountOut = shortPathAmountOut;
        }

        return (optimalPath, optimalAmountOut, cycle);
    }

    function extendPath(
        uint256 amountIn,
        address[] memory optimalPath,
        uint256 optimalAmountOut,
        Cycle memory cycle,
        uint8 maximumCycles
    ) internal view returns (address[] memory, uint256) {
        for (uint8 cycles = 0; cycles < maximumCycles; cycles++) {
            address[] memory newPath = new address[](optimalPath.length + 3);

            for (uint8 index = 0; index < optimalPath.length; index++) {
                newPath[index] = optimalPath[index];
            }

            newPath[optimalPath.length] = cycle.first;
            newPath[optimalPath.length + 1] = cycle.second;
            newPath[optimalPath.length + 2] = cycle.third;

            uint256 newAmountOut = router.getAmountsOut(amountIn, newPath)[
                newPath.length - 1
            ];

            if (newAmountOut > optimalAmountOut) {
                optimalAmountOut = newAmountOut;
                optimalPath = newPath;
            } else {
                break;
            }
        }

        return (optimalPath, optimalAmountOut);
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address tokenFrom,
        address tokenTo,
        address to,
        uint8 maximumCycles,
        uint deadline
    ) external returns (address[] memory, uint256[] memory) {
        address thirdToken;
        {
            if (token1 != tokenFrom && token1 != tokenTo) thirdToken = token1;
            else if (token2 != tokenFrom && token2 != tokenTo)
                thirdToken = token2;
            else thirdToken = token3;
        }

        (
            address[] memory optimalPath,
            uint256 optimalAmountOut,
            Cycle memory cycle
        ) = getOptimalInitalPath(amountIn, tokenFrom, tokenTo, thirdToken);

        {
            (optimalPath, optimalAmountOut) = extendPath(
                amountIn,
                optimalPath,
                optimalAmountOut,
                cycle,
                maximumCycles
            );
        }

        require(optimalAmountOut >= amountOutMin);

        TransferHelper.safeApprove(tokenFrom, address(router), amountIn);

        uint[] memory swapAmounts = router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            optimalPath,
            to,
            deadline
        );

        return (optimalPath, swapAmounts);
    }
}
