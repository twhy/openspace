// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IBank {
    function withdraw(address payable receiver, uint256 amount) external;
}

abstract contract Bank {
    address public admin;
    mapping(address => uint) public balances;
    Account[3] public top3;
    struct Account {
        uint256 balance;
        address addrese;
    }

    constructor() {
        admin = msg.sender;
    }

    function updateTop3(address addrese, uint256 balance) internal {
        Account memory account = Account({ balance: balance, addrese: addrese });
        for (uint i = 0; i < top3.length; i++) {
            if (balance > top3[i].balance) {
                if (addrese != top3[i].addrese) {
                    // shift the array to make space for the new account
                    for (uint j = top3.length - 1; j > i; j--) {
                        top3[j] = top3[j - 1];
                    }
                }
                top3[i] = account;
                break;
            }
        }
    }
}

contract BigBank is Bank {

    modifier adminOnly() {
        require(admin == msg.sender);
        _;
    }

    modifier greaterThanMilliEther() {
        require(msg.value > 0.001 ether);
        _; 
    }

    receive() external payable greaterThanMilliEther {
        balances[msg.sender] += msg.value;
        updateTop3(msg.sender, balances[msg.sender]);
    }

    function changeAdmin(address newAdmin) public adminOnly {
        admin = newAdmin;
    }

    function withdraw(address payable receiver, uint256 amount) public adminOnly {
        address self = address(this);
        require(self.balance >= amount);
        receiver.transfer(amount);
    }
}

contract Ownable {
    function withdraw(address bank, address payable receiver, uint256 amount) external {
        IBank(bank).withdraw(receiver, amount);
    }
}