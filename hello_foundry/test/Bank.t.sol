// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {Bank} from '../src/Bank.sol';

contract BankTest is Test {
    Bank public bank;

    event Deposit(address indexed user, uint amount);

    function setUp() public {
        bank = new Bank();
    }

    function test_Deposit() public {
        vm.expectEmit(true, false, false, true);
        emit Deposit(address(this), 100);

        bank.depositETH{value: 100}();
        assertEq(bank.balanceOf(address(this)), 100);

        vm.expectEmit(true, false, false, true);
        emit Deposit(address(this), 200);

        bank.depositETH{value: 200}();
        assertEq(bank.balanceOf(address(this)), 300);
    }
}