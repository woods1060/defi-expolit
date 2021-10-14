//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.2;

contract DAO {
    mapping(address => uint) public balances;

    function addToBalance() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawBalance() external {
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amount)("");
        require(success, "Failed to transfer to the sender.");
    }
}
