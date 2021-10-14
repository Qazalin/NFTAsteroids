const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyEpicNFT", function () {
  it("Should not be able to buy a nft with a lower price", async function () {
    const nftContractFactory = await hre.ethers.getContractFactory('Asteroids');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    // token uri isn't really important
    // mint an nft with id = 0 
    const txn = await nftContract.makeNFT("0.json", {
      value: ethers.utils.parseEther("0.005")
    });
    await expect(txn).to.be.revertedWith("Ether value sent is not correct'");
  });
});
