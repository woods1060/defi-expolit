require("@nomiclabs/hardhat-waffle");
require('dotenv').config();

module.exports = {
  solidity: "0.7.5",
  networks: {
    hardhat: {
      forking: {
        // url: process.env.FORKING_URL,
        url: "https://eth-mainnet.alchemyapi.io/v2/XcQ7Y9p7YQ29xZgFgt3IjM98AU44xZjt",
        blockNumber: 11388181
      }
    }
  }
};
