const ethers = require('ethers');
const { abi, bytecode, contractName } = require('./artifacts/DAO.json');
import "./index.scss";

document.getElementById("btn").addEventListener("click", () => {
  window.ethereum.request({ method: 'eth_requestAccounts' }).then((accounts) => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner(0);
    const factory = new ethers.ContractFactory(abi, bytecode, signer);

    factory.deploy().then((args) => {
      console.log(args);
    });
  });
});
