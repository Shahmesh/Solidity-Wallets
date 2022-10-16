// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract basicWallet {
    // Define owner
    address payable public owner;

    constructor() {
    	owner == payable(msg.sender);
    }

    // Show balance 
    function balanceOf() public view returns(uint) {
	return address(this).balance;
   }

    // Define received balance + Deposit funds
    uint public balanceReceived; 
    function deposit() public payable {
	balanceReceived += msg.value;
   } 
								   
   // Withdraw funds
   function withdrawFunds(uint _amount) external {
       require(msg.sender == owner);	
       payable(msg.sender).transfer(_amount);
   }

   receive() external payable {}

}   											
