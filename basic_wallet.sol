// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract basicWallet {
    // Define owner
    address payable owner;

    constructor() {
    	owner == payable(msg.sender);
    }
    
    mapping(address => uint) public balanceReceived;
    
    // Show balance 
    function balanceOf() public view returns(uint) {
	return address(this).balance;
   }

    // Define received balance + Deposit funds
    function deposit() public payable {
        balanceReceived[msg.sender] += msg.value; 
    }
								   
   // Withdraw funds
   function withdrawFunds(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough funds, aborting");
            balanceReceived[msg.sender] -= _amount;
            _to.transfer(_amount);
    }

   receive() external payable {}

}   											
