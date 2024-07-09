// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface TokenRecipient {
    function tokensReceived(address sender, uint256 amount) external returns (bool);
}

contract BaseERC20 {
    string public name; 
    string public symbol; 
    uint8 public decimals; 

    uint256 public totalSupply; 

    mapping (address => uint256) balances; 

    mapping (address => mapping (address => uint256)) allowances; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        name = "BaseERC20";
        symbol = "BERC20";
        decimals = 18;
        totalSupply = 1e8 * 1e18;
        balances[msg.sender] = totalSupply;  
    }

    function isContract(address addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return (size > 0);
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);  
        return true; 
    }

    function transferAndCall(address _to, uint256 _value) public returns (bool success) {
        transfer(_to, _value);

        if (isContract(_to)) {
            require(TokenRecipient(_to).tokensReceived(msg.sender, _value), "No tokensReceived");
        }

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (_from == msg.sender) {
            return transfer(_to, _value);
        }

        require(balances[_from] >= _value, "ERC20: transfer amount exceeds balance");
        require(allowances[_from][msg.sender] >= _value, "ERC20: transfer amount exceeds allowance");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value); 
        return true; 
    }

    function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool success) {
        transferFrom(_from, _to, _value);

        if (isContract(_to)) {
            require(TokenRecipient(_to).tokensReceived(_from, _value), "No tokensReceived");
        }

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] += _value;
        emit Approval(msg.sender, _spender, _value); 
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {   
        return allowances[_owner][_spender];
    }
}