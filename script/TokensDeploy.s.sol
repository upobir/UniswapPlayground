// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "v2-core/interfaces/IUniswapV2Factory.sol";
import "v2-core/interfaces/IUniswapV2Pair.sol";
import "v2-periphery/interfaces/IUniswapV2Router02.sol";
import "@uniswap/lib/contracts/libraries/TransferHelper.sol";

import {AlphaToken, BravoToken, CharlieToken, WethToken} from "../src/Tokens.sol";

contract TokensDeploy is Script {
    function run() public {
        vm.startBroadcast();

        WethToken weth = new WethToken();
        AlphaToken alpha = new AlphaToken();
        BravoToken bravo = new BravoToken();
        CharlieToken charlie = new CharlieToken();

        alpha.mint(100);
        bravo.mint(100);
        charlie.mint(100);

        vm.stopBroadcast();

        console.log("Weth: %s", address(weth));
        console.log("Alpha: %s", address(alpha));
        console.log("Bravo: %s", address(bravo));
        console.log("Charlie: %s", address(charlie));
    }
}
