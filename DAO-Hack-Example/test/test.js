const { assert } = require("chai");

describe("The DAO", function() {
  let dao;
  let addresses;
  let user;
  let attacker;
  beforeEach(async () => {
    addresses = await ethers.provider.listAccounts();
    const DAO = await ethers.getContractFactory("DAO");
    dao = await DAO.deploy();

    const User = await ethers.getContractFactory("User");
    user = await User.deploy(dao.address);
    await user.deposit({
      value: ethers.utils.parseEther("1")
    });

    const Attacker = await ethers.getContractFactory("Attacker");
    attacker = await Attacker.deploy(dao.address);
    await attacker.deposit({
      value: ethers.utils.parseEther("1")
    });
  });

  it("should allow us to look up the user balance", async function() {
    const balance = await dao.balances(user.address);

    assert.equal(
      balance.toString(),
      ethers.utils.parseEther("1").toString()
    );
  });

  it("should allow us to look up the attacker balance", async function() {
    const balance = await dao.balances(attacker.address);

    assert.equal(
      balance.toString(),
      ethers.utils.parseEther("1").toString()
    );
  });

  describe('the attacker withdraws', () => {
    beforeEach(async () => {
      await attacker.withdraw();
    });

    it('should still have the user funds', async () => {
      const balance = await ethers.provider.getBalance(dao.address);
      assert.equal(
        balance.toString(),
        ethers.utils.parseEther("1").toString()
      );
    });
  });
});
