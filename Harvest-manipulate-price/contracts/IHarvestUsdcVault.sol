//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

interface IHarvestUsdcVault {
    function deposit(uint256 amountWei) external;

    function withdraw(uint256 numberOfShares) external;

    function balanceOf(address account) external view returns (uint256);
}