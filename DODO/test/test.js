// const {assert} = require("chai");
// const { ethers } = require("hardhat");
// const { big } = require("big.js");

// const wallet = "0x0B61982356cF13D4CAAACa906f0fD8CB1e3d1e76";

// describe("DODO_FlashLoan-attack-replay",function(){

//     before(async function(){
//         // usdt = await ethers.getContractAt("TetherToken",usdtAdddress);
//         // wcres = await ethers.getContractAt("WrappedERC20".wcresAddress);
//         const Token1 = await ethers.getContractFactory("_ERC20");
//         const Token2 = await ethers.getContractFactory("_ERC20");

//         let token1 = await Token1.deploy("token1","t1",18,big(100000000000000000000),"CAPPED");
//         let token2 = await Token2.deploy("token2","t2",18,big(100000000000000000000),"CAPPED");

//         await token1.deployed();
//         await token2.deployed();

//         await token1.transfer(wallet,big(1000000000000000000));
//         await token2.transfer(wallet,big(1000000000000000000));
//     });
//     it("exploit",async function(){
//         const balance1 = await token1.balanceOf(wallet);
//         assert.equal(balance1,10000000000000000000000000,"Expected equal")
//     });

// });