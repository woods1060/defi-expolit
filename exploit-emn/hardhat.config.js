require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.6.6",
  networks: {
    hardhat: {
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/kixfCo4SQqpUcT81nno3AG6g_r1R2f77",
        blockNumber: 10954410
      }
    }
  }
};
