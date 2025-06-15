//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BookingToken is ERC20 {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function mint(address account, uint256 amount) internal {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) internal {
        _burn(account, amount);
    }
}