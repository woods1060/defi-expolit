pragma solidity ^0.6.2;

import "./DAO.sol";

contract User {
    DAO dao;

    constructor(address _daoAddress) public {
        dao = DAO(_daoAddress);
    }

    receive() external payable {}

    function deposit() external payable {
        dao.addToBalance.value(address(this).balance)();
    }

    function withdraw() external {
        dao.withdrawBalance();
    }
}
