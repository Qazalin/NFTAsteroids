const { ethers } = require("hardhat");

const main = async () => {
    // compile the contract and generate the filess we need in artifacts dir
    const nftContractFactory = await hre.ethers.getContractFactory('Asteroids');
    // create a local blockchain
    // deploy the contract and run the constuctor (args for deploy method)
    const nftContract = await nftContractFactory.deploy();
    // mine the contract
    await nftContract.deployed();
    // get the address
    console.log("Contract deployed to:", nftContract.address);

    // constants 
    const baseURI = "https://gateway.pinata.cloud/ipfs/QmUywn1FX3YZYQrszoE3qu6G9UjS6xtYJwK8VeAwFQ8uke/"

    // mint an nft with id = 0 
    let txn = await nftContract.makeNFT(baseURI + "0.json", {
        value: ethers.utils.parseEther("0.005")
    });
    // wait for it to be mined
    await txn.wait(1);

    let view = await nftContract.tokenURI(0)
    console.log("the nft uri is:", view)
};

// this methodology is recomended for catching errors and debugging
const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();