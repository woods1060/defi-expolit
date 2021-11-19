const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Expolit", function () {
  it("Expolit Harvest", async function () {
   const Expoliter = await ethers.getContractFactory("Expolit");
   const expolit = await Expoliter.deploy();
   await expolit.deployed();
   console.log(`Expoliter depolyed at ${expolit.address}`);
   await expolit.start();
  });
});

async function main() {
  
}