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
 
  const Test = await ethers.getContractFactory("Attack");
  const test = await Test.deploy();
  await test.deployed();
  await test.start();

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// npx hardhat run scripts/attack.js 