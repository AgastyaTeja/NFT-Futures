import { expect } from "chai";
import { ethers, network } from "hardhat";

describe("placeABid", function () {
  it("Place a Bid on a NFT Collection", async function () {

    const [owner, addr1, addr2] = await ethers.getSigners();
    const address = await owner.getAddress();
    await network.provider.send("hardhat_setBalance", [
            address,
            "0x110999921435922880",
      ]);

    const NFTFuturesBetting = await ethers.getContractFactory("NFTFuturesBetting");
    const nftFuturesBetting = await NFTFuturesBetting.deploy();
    await nftFuturesBetting.deployed();

    expect(await nftFuturesBetting.placeABid("Test NFT","Floor Price", 100));

  });
});
