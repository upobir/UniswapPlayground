// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "v2-core/interfaces/IUniswapV2Factory.sol";
import "v2-core/interfaces/IUniswapV2Pair.sol";
import "v2-periphery/interfaces/IUniswapV2Router02.sol";
import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

import {AlphaToken, BravoToken, CharlieToken, WethToken} from "../src/Tokens.sol";
import {OptimalSwapper} from "../src/OptimalSwapper.sol";

contract TokensDeploy is Script {
    AlphaToken alpha = AlphaToken(vm.envAddress("ALPHA_ADDRESS"));
    BravoToken bravo = BravoToken(vm.envAddress("BRAVO_ADDRESS"));
    CharlieToken charlie = CharlieToken(vm.envAddress("CHARLIE_ADDRESS"));
    WethToken weth = WethToken(vm.envAddress("WETH_ADDRESS"));

    IUniswapV2Factory uniswapFactory =
        IUniswapV2Factory(vm.envAddress("UNISWAP_FACTORY_ADDRESS"));
    IUniswapV2Router02 uniswapRouter =
        IUniswapV2Router02(vm.envAddress("UNISWAP_ROUTER_ADDRESS"));

    function getName(address token) public view returns (string memory) {
        if (token == address(alpha)) return "alpha";
        else if (token == address(bravo)) return "bravo";
        else if (token == address(charlie)) return "charlie";
        else return "unknown";
    }

    function run() public {
        vm.startBroadcast();

        OptimalSwapper swapper = new OptimalSwapper(
            address(alpha),
            address(bravo),
            address(charlie),
            address(uniswapRouter)
        );

        TransferHelper.safeTransfer(address(bravo), address(swapper), 200);

        (address[] memory path, uint[] memory amounts) = swapper
            .swapExactTokensForTokens(
                200,
                0,
                address(bravo),
                address(alpha),
                msg.sender,
                1,
                1704486188
            );

        vm.stopBroadcast();

        for (uint8 index = 0; index < path.length; index++) {
            console.log(
                "step %s: token: %s, amount: %s",
                index,
                getName(path[index]),
                amounts[index]
            );
        }

        console.log(
            "Swap amounts: %s & %s",
            amounts[0],
            amounts[amounts.length - 1]
        );
    }
}
