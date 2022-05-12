//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
pragma abicoder v2;

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IWETH.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import {IContractRegistry, IBancorNetwork} from '../interfaces/IBancor.sol';
import '../interfaces/IAaveProtocolDataProvider.sol';
import '../interfaces/ICroDefiSwapRouter02.sol';
import '../interfaces/MyILendingPool.sol';
import '../interfaces/IDODOProxyV2.sol';
import '../interfaces/IBalancerV1.sol';
import '../interfaces/MyIERC20.sol';
import '../interfaces/ICurve.sol';
import '../periphery/Helpers.sol';
import '../periphery/Exchange.sol'; 

import "hardhat/console.sol";


contract Flashloaner is Ownable, Helpers {

    MyIERC20 USDT = MyIERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    MyIERC20 WBTC = MyIERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    MyIERC20 WETH = MyIERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    MyIERC20 USDC = MyIERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    MyIERC20 BNT = MyIERC20(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
    MyIERC20 TUSD = MyIERC20(0x0000000000085d4780B73119b644AE5ecd22b376);
    MyIERC20 ETH = MyIERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    IWETH WETH_int = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    MyILendingPool lendingPoolAAVE = MyILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
    IContractRegistry ContractRegistry_Bancor = IContractRegistry(0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4);
    ICurve yPool = ICurve(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    ICurve dai_usdc_usdt_Pool = ICurve(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);
    IUniswapV2Router02 sushiRouter = IUniswapV2Router02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
    IUniswapV2Router02 uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IBancorNetwork bancorNetwork = IBancorNetwork(IContractRegistry(ContractRegistry_Bancor).addressOf('BancorNetwork'));
    IBalancerV1 balancerWBTCETHpool_1 = IBalancerV1(0x221BF20c2Ad9e5d7eC8a9d1991d8E2EdcfCb9d6c);
    IBalancerV1 balancerWBTCETHpool_2 = IBalancerV1(0x1efF8aF5D577060BA4ac8A29A13525bb0Ee2A3D5);
    IBalancerV1 balancerETHUSDCpool = IBalancerV1(0x8a649274E4d777FFC6851F13d23A86BBFA2f2Fbf);
    IDODOProxyV2 dodoProxyV2 = IDODOProxyV2(0xa356867fDCEa8e71AEaF87805808803806231FdC);
    ICroDefiSwapRouter02 croDefiRouter = ICroDefiSwapRouter02(0xCeB90E4C17d626BE0fACd78b79c9c87d7ca181b3);
    IAaveProtocolDataProvider aaveProtocolDataProvider = IAaveProtocolDataProvider(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d); 
    Exchange exchange;


    address myExchange;
    address revengeOfTheFlash;
    address offchainRelayer;


    constructor(address _myExchange, address _revengeOfTheFlash, address _offchainRelayer) {
        myExchange = _myExchange;
        revengeOfTheFlash = _revengeOfTheFlash;
        offchainRelayer = _offchainRelayer;
    }


    function setExchange(Exchange _myExchange) public {
        exchange = _myExchange;
    }

    // function setDydxFlashloanerSecondOwner(address _dydxFlashloaner) external onlyOwner {
    //     _setSecondaryOwner(_dydxFlashloaner);
    // }

    receive() external payable {}

    modifier onlySecondaryOwner {

        _;
    }


    function execute(uint _borrowed) external onlySecondaryOwner {
        //General variables
        bool success;
        bytes memory returnData;
        uint tradedAmount;

        //AAVE
        uint usdcWithdrawal = 17895868 * 10 ** 6;
        WETH.approve(address(lendingPoolAAVE), type(uint).max); 
        lendingPoolAAVE.deposit(address(WETH), _borrowed, address(this), 0); 
        console.log('2.- AAVE - Deposit WETH: ', _borrowed / 1 ether);

        lendingPoolAAVE.withdraw(address(USDC), usdcWithdrawal, address(this)); 
        uint usdcBalance = USDC.balanceOf(address(this)); 
        console.log('3.- AAVE --- withdraw USDC: ', usdcBalance / 10 ** 6);

        //MY EXCHANGE - (USDC to BNT)
        USDC.transfer(offchainRelayer, 11184.9175 * 10 ** 6);
        (success, returnData) = myExchange.call(
            abi.encodeWithSignature(
                'withdrawFromPool(address,address,uint256)', 
                BNT, address(this), 1506.932141071984328329 * 1 ether
            )
        );
        if (!success) console.log(_getRevertMsg(returnData));
        require(success, 'USDC/BNT withdrawal from pool failed');
        console.log('4.- myEXCHANGE - BNT: ', BNT.balanceOf(address(this)) / 1 ether);
       
        //BANCOR - (USDC to BNT)
        tradedAmount = swapToExchange(
            abi.encodeWithSignature(
                'bancorSwap(address,address,uint256)', 
                USDC, BNT, 883608.4825 * 10 ** 6
            ), 
            'Bancor USDC/BNT',
            myExchange
        );
        console.log('5.- BANCOR --- BNT: ', tradedAmount / 1 ether);
        console.log('___5.1.- BNT balance (after swap): ', BNT.balanceOf(address(this)) / 1 ether);

        //BANCOR - (BNT to ETH)
        tradedAmount = swapToExchange(
            abi.encodeWithSignature(
                'bancorSwap(address,address,uint256)', 
                BNT, ETH, BNT.balanceOf(address(this))
            ), 
            'Bancor BNT/ETH',
            myExchange
        );
        console.log('6.- BANCOR --- ETH: ', tradedAmount / 1 ether); 

        //CURVE - (USDC to TUSD)
        swapToExchange(
            abi.encodeWithSignature(
                'curveSwap(address,address,uint256,int128,int128,uint256)', 
                yPool, USDC, 894793.4 * 10 ** 6, 1, 3, 1
            ), 
            'Curve USDC/TUSD',
            myExchange 
        );
        console.log('7.- CURVE --- TUSD: ', TUSD.balanceOf(address(this)) / 1 ether);

        //SUSHISWAP - (TUSD to ETH)
        tradedAmount = swapToExchange(
            abi.encodeWithSignature(
                'sushiUniCro_swap(address,uint256,address,address,uint256)', 
                sushiRouter, 11173.332238593491520262 * 1 ether, TUSD, WETH, 1
            ), 
            'Sushiswap TUSD/ETH',
            myExchange
        );
        console.log('8.- SUSHISWAP --- ETH: ', tradedAmount / 1 ether, '--', tradedAmount);

        //Moving to Revenge
        (bool _success, bytes memory data) = revengeOfTheFlash.delegatecall( 
            abi.encodeWithSignature(
            'executeCont()')
        );
        if (!_success) console.log(_getRevertMsg(data));
        require(_success, 'Delegatecall to Revenge of The Flash failed');

    }
}






