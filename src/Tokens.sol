//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AlphaToken is ERC20, Ownable {
    constructor() ERC20("AlphaToken", "AT") Ownable(msg.sender) {}

    function mint(uint amount) public onlyOwner {
        _mint(msg.sender, amount * 10 ** 18);
    }
}

contract BravoToken is ERC20, Ownable {
    constructor() ERC20("BravoToken", "BT") Ownable(msg.sender) {}

    function mint(uint amount) public onlyOwner {
        _mint(msg.sender, amount * 10 ** 18);
    }
}

contract CharlieToken is ERC20, Ownable {
    constructor() ERC20("CharlieToken", "CT") Ownable(msg.sender) {}

    function mint(uint amount) public onlyOwner {
        _mint(msg.sender, amount * 10 ** 18);
    }
}

contract WethToken is ERC20, Ownable {
    constructor() ERC20("Weth Token", "WETH") Ownable(msg.sender) {}

    function mint(uint amount) public onlyOwner {
        _mint(msg.sender, amount * 10 ** 18);
    }
}
