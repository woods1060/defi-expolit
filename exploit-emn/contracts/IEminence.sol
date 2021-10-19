//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.6;

import '@uniswap/v2-core/contracts/interfaces/IERC20.sol';

interface IEminence is IERC20 {
    function buy(uint _amount, uint _min) external returns (uint _bought);
    function sell(uint _amount, uint _min) external returns (uint _bought);
}
