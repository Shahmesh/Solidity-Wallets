// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract guardiansWallet {

    address payable public owner;

    constructor() {
        owner == payable(msg.sender);
    }

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    mapping(address => bool) public guardians;
    address payable nextOwner;
    mapping(address => mapping(address => bool)) nextGuardianVotedBool;
    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "Caller is not owner, aborting");
        guardians[_guardian] = _isGuardian;
    }

    function chooseNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "You are not a guardian, aborting");
        require(nextGuardianVotedBool[_newOwner][msg.sender] == false, "You already voted, aborting");
        if(_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }

        guardiansResetCount++;

        if(guardiansResetCount >= confirmationsFromGuardiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }



    function setAllowance(address _for, uint _amount) public {
        require(msg.sender == owner, "Caller is not owner, aborting");
        allowance[msg.sender] = _amount;

        if(_amount > 0) {
            isAllowedToSend[_for] = true;
        } else {
            isAllowedToSend[_for] = false;
        }
    }

    function transferFunds(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory) {
        if(msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You are not allowed to send from this contract, aborting");
            require(allowance[msg.sender] >= _amount, "You are trying to send more funds than allowed, aborting");
        
            allowance[msg.sender] -= _amount;
        }

    (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);

    require(success, "Aborting, call was not successful");
    return returnData;
    }

    receive() external payable {}

}
