//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

interface IcurveYSwap {
    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;
    // dx is in, dy is out.
    // 0 is yDAI
    // 1 is yUSDC
    // 2 is yUSDT
    // 3 is yTUSD
}