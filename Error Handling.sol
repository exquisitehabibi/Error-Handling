//Contract successfully uses require()
//Contract successfully uses assert()
//Contract successfully uses revert() statements

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TokenManagement {
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances; // approval mapping

    address public owner;

    event TokensAdded(address indexed to, uint amount);
    event TokensWithdrawn(address indexed from, uint amount);
    event TokensTransferred(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);

    constructor() {
        owner = msg.sender; // set deployer as owner
    }

    function add_mintTokens(address to, uint amt) public {
        require(msg.sender == owner, "Only the owner can add tokens"); // require the sender is the owner
        assert(amt > 0); // assert the amount added is positive
        balances[to] += amt;
        emit TokensAdded(to, amt);
    }

    function withdrawTokens(uint amt) public {
        if (balances[msg.sender] < amt) {
            revert("Insufficient balance to withdraw"); // revert the transaction if the sender has insufficient balance
        }
        balances[msg.sender] -= amt;
        emit TokensWithdrawn(msg.sender, amt);
    }

    function approve(address spender, uint amt) public {
        require(msg.sender == owner, "Only the owner can grant/approve allowance"); // require the owner is the approver
        require(spender != address(0), "Cannot approve to zero address"); //require the spender address is not zero
        require(amt > 0, "Approval amount must be greater than zero"); // require the approval amount is positive
        allowances[msg.sender][spender] = amt;
        emit Approval(msg.sender, spender, amt);
    }

    function transferFrom(address from, address to, uint amt) public { // allows a spender to transfer tokens from a user's account to another account
        if (allowances[from][msg.sender] < amt) { 
            revert("Allowance exceeded"); // revert if allowance is insufficient
        }
        if (balances[from] < amt) {
            revert("Insufficient balance"); // revert if balance is insufficient
        }
        
        allowances[from][msg.sender] -= amt;
        balances[from] -= amt;
        balances[to] += amt;
        
        emit TokensTransferred(from, to, amt);
    }

    function transfer(address to, uint amt) public { // allows a user to transfer tokens from their own balance to another address
        if (balances[msg.sender] < amt) {
            revert("Insufficient balance"); // revert if balance is insufficient
        }
        
        balances[msg.sender] -= amt;
        balances[to] += amt;
        
        emit TokensTransferred(msg.sender, to, amt);
    }
}
