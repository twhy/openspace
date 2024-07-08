// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "contracts/BaseERC20.sol";

contract TokenBank {
    mapping(address => mapping (address => uint256)) public balances;

    function deposit(address token, uint256 value) public payable returns (bool) {
        BaseERC20 coin = BaseERC20(token);
        require(coin.balanceOf(msg.sender) >= value, "Not enough token");
        require(coin.transferFrom(msg.sender, address(this), value), "Transfer failed");
        balances[token][msg.sender] += value;
        return true;
    }

    function withdraw(address token, uint256 value) public payable returns (bool) {
        require(balances[token][msg.sender] >= value, "Not enough token");
        require(BaseERC20(token).transfer(msg.sender, value), "Transfer failed");
        balances[token][msg.sender] -= value;
        return true;
    }
}