require("@nomiclabs/hardhat-web3");


async function main() {
    const WETH = await Web3.
}

main()
    .then( () => process.exit(0) )
    .catch(error => {
        console.error(error);
        process.exit(1);
    })