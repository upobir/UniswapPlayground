// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "v2-core/interfaces/IUniswapV2Factory.sol";
import "v2-core/interfaces/IUniswapV2Pair.sol";
import "v2-periphery/interfaces/IUniswapV2Router02.sol";

import {AlphaToken, BravoToken, CharlieToken, WethToken} from "../src/Tokens.sol";

contract TripleTokenScript is Script {
    AlphaToken alpha;
    BravoToken bravo;
    CharlieToken charlie;
    WethToken weth;
    IUniswapV2Factory uniswapFactory;
    IUniswapV2Router02 uniswapRouter;

    IUniswapV2Pair pairAB;
    IUniswapV2Pair pairBC;
    IUniswapV2Pair pairCA;

    function setUpTokens() public {
        vm.startBroadcast();
        weth = new WethToken();
        alpha = new AlphaToken();
        bravo = new BravoToken();
        charlie = new CharlieToken();

        alpha.mint(100);
        bravo.mint(100);
        charlie.mint(100);
        weth.mint(100);
        vm.stopBroadcast();
    }

    function setUpUniswap() public {
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

        vm.stopBroadcast();

        console.log("uniswapFactory address: %s", address(uniswapFactory));
    }

    function setUpPools() public {
        vm.startBroadcast();

        alpha.approve(address(uniswapRouter), 100 * 10 ** 18);
        bravo.approve(address(uniswapRouter), 100 * 10 ** 18);
        charlie.approve(address(uniswapRouter), 100 * 10 ** 18);

        pairAB = createPoolAndAddLiquidity(
            address(alpha),
            address(bravo),
            1 * 10 ** 12,
            2 * 10 ** 12,
            "Alpha-Bravo"
        );
        pairBC = createPoolAndAddLiquidity(
            address(bravo),
            address(charlie),
            2 * 10 ** 12,
            5 * 10 ** 12,
            "Bravo-Charlie"
        );
        pairCA = createPoolAndAddLiquidity(
            address(charlie),
            address(alpha),
            4 * 10 ** 12,
            1 * 10 ** 12,
            "Charlie-Alpha"
        );

        vm.stopBroadcast();
    }

    function setUp() public {
        setUpTokens();

        setUpUniswap();

        setUpPools();
    }

    function createPoolAndAddLiquidity(
        address token1,
        address token2,
        uint256 amount1,
        uint256 amount2,
        string memory poolName
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

        (uint256 reserve1, uint256 reserve2, ) = pair.getReserves();
        console.log("%s Reserves: %s & %s", poolName, reserve1, reserve2);

        return pair;
    }

    function run() public {
        vm.startBroadcast();
        uint256 balance1;
        uint256 balance2;

        balance1 = alpha.balanceOf(msg.sender);
        balance2 = bravo.balanceOf(msg.sender);

        console.log("Alpha & Bravo Balance: %s & %s", balance1, balance2);

        address[] memory path = new address[](2);
        path[0] = address(alpha);
        path[1] = address(bravo);

        uint[] memory amounts = uniswapRouter.swapExactTokensForTokens(
            1000000,
            5,
            path,
            msg.sender,
            1704486188
        );

        console.log("Transfer amounts: %s & %s", amounts[0], amounts[1]);

        balance1 = alpha.balanceOf(msg.sender);
        balance2 = bravo.balanceOf(msg.sender);

        console.log("Alpha & Bravo Balance: %s & %s", balance1, balance2);

        vm.stopBroadcast();
    }
}
