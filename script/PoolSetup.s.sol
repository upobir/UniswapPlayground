// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "v2-core/interfaces/IUniswapV2Factory.sol";
import "v2-core/interfaces/IUniswapV2Pair.sol";
import "v2-periphery/interfaces/IUniswapV2Router02.sol";
import "@uniswap/lib/contracts/libraries/TransferHelper.sol";

import {AlphaToken, BravoToken, CharlieToken, WethToken} from "../src/Tokens.sol";

contract TokensDeploy is Script {
    AlphaToken alpha = AlphaToken(vm.envAddress("ALPHA_ADDRESS"));
    BravoToken bravo = BravoToken(vm.envAddress("BRAVO_ADDRESS"));
    CharlieToken charlie = CharlieToken(vm.envAddress("CHARLIE_ADDRESS"));
    WethToken weth = WethToken(vm.envAddress("WETH_ADDRESS"));

    IUniswapV2Factory uniswapFactory;
    IUniswapV2Router02 uniswapRouter;

    IUniswapV2Pair pairAB;
    IUniswapV2Pair pairBC;
    IUniswapV2Pair pairCA;

    function createPoolAndAddLiquidity(
        address token1,
        address token2,
        uint256 amount1,
        uint256 amount2
    ) public returns (IUniswapV2Pair) {
        IUniswapV2Pair pair = IUniswapV2Pair(
            uniswapFactory.createPair(token1, token2)
        );

        uniswapRouter.addLiquidity(
            token1,
            token2,
            amount1,
            amount2,
            0,
            0,
            msg.sender,
            1704486188
        );

        return pair;
    }

    function run() public {
        vm.startBroadcast();

        uniswapFactory = IUniswapV2Factory(
            deployCode(
                "MyUniswapV2Factory.sol:UniswapV2Factory",
                abi.encode(msg.sender)
            )
        );
        uniswapRouter = IUniswapV2Router02(
            deployCode(
                "MyUniswapV2Router02.sol:UniswapV2Router02",
                abi.encode(address(uniswapFactory), address(weth))
            )
        );

        TransferHelper.safeApprove(
            address(alpha),
            address(uniswapRouter),
            100 * 10 ** 18
        );
        TransferHelper.safeApprove(
            address(bravo),
            address(uniswapRouter),
            100 * 10 ** 18
        );
        TransferHelper.safeApprove(
            address(charlie),
            address(uniswapRouter),
            100 * 10 ** 18
        );

        pairAB = createPoolAndAddLiquidity(
            address(alpha),
            address(bravo),
            1 * 10 ** 12,
            2 * 10 ** 12
        );
        pairBC = createPoolAndAddLiquidity(
            address(bravo),
            address(charlie),
            2 * 10 ** 12,
            3 * 10 ** 12
        );
        pairCA = createPoolAndAddLiquidity(
            address(charlie),
            address(alpha),
            3 * 10 ** 12,
            2 * 10 ** 12
        );

        vm.stopBroadcast();

        console.log("uniswapFactory: %s", address(uniswapFactory));
        console.log("uniswapRouter: %s", address(uniswapRouter));
    }
}
