const { assert } = require("chai");

const address = "0xbf4ed7b27f1d666546e30d74d50d173d20bca754";
const reddit = "0xD8B76c4a26403FAcdCFdfE4638a31D08110876Df";
const daoAddress = "0xbb9bc244d798123fde783fcc1c72d3bb8c189413";

describe("WithdrawDAO", function() {
  const oneGwei = ethers.utils.parseUnits("1", "gwei");
  let withdrawDAO;
  let dao;
  beforeEach(async () => {
    withdrawDAO = await ethers.getContractAt("WithdrawDAO", address);
    dao = await ethers.getContractAt("DAO", daoAddress);

    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [reddit]
    });
  });

  it("should have a trustee", async () => {
    // approve theDAO tokens on the dao
    const balance = await dao.balanceOf(reddit);
    const redditSigner = ethers.provider.getSigner(reddit);

    await dao.connect(redditSigner).approve(withdrawDAO.address, balance, {
      gasPrice: oneGwei,
      gasLimit: 65940,
    });
    await withdrawDAO.connect(redditSigner).withdraw({
      gasPrice: oneGwei,
      gasLimit: 118908,
    });

    const balanceETH = await ethers.provider.getBalance(reddit);
    console.log(ethers.utils.formatEther(balanceETH));
  });
});
