const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Attacker = await ethers.getContractFactory("attack");
    const attacker = await Attacker.deploy();
    await attacker.deployed();

  });
});
