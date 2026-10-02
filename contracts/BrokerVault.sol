// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVault {
    function depositFor(address user) external payable;
    function withdrawFor(address payable user, uint256 amount) external;
    function getBalance(address user) external view returns (uint256);
}

contract Vault is IVault {
    mapping(address => uint256) private balances;

    function depositFor(address user) external payable override {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[user] += msg.value;
    }

    function withdrawFor(address payable user, uint256 amount) external override {
        require(balances[user] >= amount, "Insufficient funds in vault");
        balances[user] -= amount;
        
        (bool success, ) = user.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function getBalance(address user) external view override returns (uint256) {
        return balances[user];
    }
}

contract Broker {
    IVault public immutable vault;

    constructor(address _vaultAddress) {
        require(_vaultAddress != address(0), "Invalid vault address");
        vault = IVault(_vaultAddress);
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        vault.depositFor{value: msg.value}(msg.sender);
    }

    function withdraw(uint256 amount) external {
        vault.withdrawFor(payable(msg.sender), amount);
    }

    function getUserBalance(address user) external view returns (uint256) {
        return vault.getBalance(user);
    }
}