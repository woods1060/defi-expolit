describe("Exploit", function() {
  it("should profit", async function() {
    const Exploit = await ethers.getContractFactory("Exploit");
    const exploit = await Exploit.deploy();
    await exploit.deployed();
    await exploit.execute();
  });
});
