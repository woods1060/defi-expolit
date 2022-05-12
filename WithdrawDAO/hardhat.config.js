require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');

module.exports = {
  solidity: "0.7.3",
  networks: {
    hardhat: {
      forking: {
        // TODO: add key here
        url: "https://eth-mainnet.alchemyapi.io/v2/XcQ7Y9p7YQ29xZgFgt3IjM98AU44xZjt",
        blockNumber: 11661763
      }
    }
  }
};
