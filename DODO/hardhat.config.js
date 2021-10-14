require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  // solidity: "0.8.4",
  solidity: {
    compilers: [
      {
        version: "0.8.4"
      },
      {
        version: "0.6.7",
        settings: { } 
      },
      {
        version: "0.4.17"
      }
    ]
  },
  networks: {
    hardhat: {
      forking: {
        // TODO: add key here
        url: "https://eth-mainnet.alchemyapi.io/v2/XcQ7Y9p7YQ29xZgFgt3IjM98AU44xZjt",
        blockNumber: 11661763
      }
    }
  }
}
