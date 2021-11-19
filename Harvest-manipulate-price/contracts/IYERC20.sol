//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

interface IYERC20 {
    //Y-token functions
    function deposit(uint256 amount) external;

    function withdraw(uint256 shares) external;

    function getPricePerFullShare() external view returns (uint256);

    function token() external returns (address);
}