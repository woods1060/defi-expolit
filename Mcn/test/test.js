// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers, network } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const sender = "0x56178a0d5F301bAf6CF3e1Cd53d9863437345Bf9";
  const Weth = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
  [add1] = await ethers.getSigners();
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [sender],
  });
 
  const signer = await ethers.provider.getSigner(sender);
  const Test = await ethers.getContractFactory("test");
  const test = await Test.deploy();
  await test.deployed();
  // 用模拟的账户给指定账户转账
  await signer.sendTransaction({
    to: test.address,
    value: ethers.utils.parseEther("3.0"),
  });
  console.log('向合约地址转账3ETH')
  await test.start();
    // 取消模拟
  await hre.network.provider.request({
    method: "hardhat_stopImpersonatingAccount",
    params: [sender],
  });

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// npx hardhat run test/test.js 