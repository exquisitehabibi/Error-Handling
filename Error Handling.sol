// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ErrorHandling {
    mapping(address => uint) public balance;
    address owner = msg.sender; 
    /*the owner address is set to be as of the sender for easy demonstration of the code.
    It can be changed to the address of account we are currently using.*/

    function addtokens(uint amt) public {
        require(msg.sender == owner, "The transaction must be done by the owner");
        assert(amt > 0);
        balance[owner] += amt;
    }

    function withdraw(uint amt) public {
        require(msg.sender == owner, "The transaction must be done by the owner");
        if(amt > balance[owner]){
            revert("The balance is insufficient for transaction");
        }
        balance[owner] -= amt;
    }

}