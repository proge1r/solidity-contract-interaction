// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract BaseVault {
    mapping(address => uint256) internal balances;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
    }
}

contract Stablecoin is BaseVault {
    address public treasury;

    constructor(address _treasury) {
        require(_treasury != address(0), "Invalid treasury address");
        treasury = _treasury;
        balances[msg.sender] = 1000000 * 10**18;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(balances[from] >= amount, "Insufficient balance");

        uint256 fee = (amount * 1) / 100;
        uint256 netAmount = amount - fee;

        balances[from] -= amount;
        balances[to] += netAmount;
        balances[treasury] += fee;

        emit Transfer(from, to, netAmount);
        emit Transfer(from, treasury, fee);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }
}