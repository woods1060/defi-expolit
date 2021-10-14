//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

interface DAO {
    function balanceOf(address addr) external view returns (uint);
    function transferFrom(address from, address to, uint balance) external returns (bool);
    function approve(address, uint) external returns (bool success);
    function totalSupply() external view returns(uint);
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413);
    address public trustee = 0xDa4a4626d3E16e094De3225A751aAb7128e96526;

    function withdraw() external {
        uint balance = mainDAO.balanceOf(msg.sender);

        if (!mainDAO.transferFrom(msg.sender, address(this), balance) || !msg.sender.send(balance))
            revert();
    }

    function trusteeWithdraw() external {
        payable(trustee).transfer((address(this).balance + mainDAO.balanceOf(address(this))) - mainDAO.totalSupply());
    }
}
