// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const {ethers,network} = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const sender = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [sender],
  });
  const signer = await ethers.provider.getSigner(sender);
  // We get the contract to deploy

  const Attacker = await hre.ethers.getContractFactory("Attack");
  const attacker = await Attacker.deploy();
  await attacker.deployed();
  ///////////////////////////////////////////////
  await signer.sendTransaction({
    to: attacker.address,
    value: ethers.utils.parseEther("66.0"),
  });
  console.log('向合约地址转账60ETH')
  await attacker.start();
    // 取消模拟
  await hre.network.provider.request({
    method: "hardhat_stopImpersonatingAccount",
    params: [sender],
  });




}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
