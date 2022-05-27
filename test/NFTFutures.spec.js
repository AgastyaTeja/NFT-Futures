const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("placeABid", function () {
  it("Place a Bid on a NFT Collection", async function () {


    // const accounts = await ethers.getSigners();

		// owner = accounts[0];
		// account1 = accounts[1];
    // account2 = accounts[2];
    const [owner, addr1, addr2] = await ethers.getSigners();
    const address = await owner.getAddress();
    const u1 = await addr1.getAddress();
    const u2 = await addr2.getAddress();
    console.log("Owner",address);
    console.log("User1",u1);
    console.log("User2",u2);

    await network.provider.send("hardhat_setBalance", [
      address,
      "0x10000000000000000000",
]);
    await network.provider.send("hardhat_setBalance", [
            u1,
            "0x10000000000000000000000",
    ]);
    
    await network.provider.send("hardhat_setBalance", [
      u2,
      "0x10000000000000000000000",      
    ]);
    const balance =   await network.provider.send("eth_getBalance", [
      u1,
    ]);
    console.log("user1 Balance",balance);

    console.log("Get contract")
    const NFTFuturesBetting = await ethers.getContractFactory("NFTFuturesBetting");
    console.log("Deploy contract")
    const nftFuturesBetting = await NFTFuturesBetting.deploy();
    console.log("Deployed");
    await nftFuturesBetting.deployed();
    console.log("Placing bets");
    const firstusertx = await nftFuturesBetting.connect(addr1).placeABid("opensea-creature","Floor Price", 100,{value:1^17});
    await firstusertx.wait();
    console.log("User1 placed the bet", addr1);
    const secondusertx = await nftFuturesBetting.connect(addr2).placeABid("opensea-creature","Floor Price", 110,{value:1^17});
    await secondusertx.wait();
    console.log("User2 placed the bet", addr2);

  });
});
