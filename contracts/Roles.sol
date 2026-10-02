// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdminRole {
    function getRole() public pure virtual returns (string memory) {
        return "Admin";
    }
}

contract UserRole {
    function getRole() public pure virtual returns (string memory) {
        return "User";
    }
}

contract SuperUser is AdminRole, UserRole {
    function getRole() public pure override(AdminRole, UserRole) returns (string memory) {
        return "SuperUser";
    }

    function getBaseRole() public pure returns (string memory) {
        return super.getRole();
    }
}