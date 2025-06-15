const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Hotel Contract", function () {
  let hotel, token, owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("BookingToken");
    token = await Token.deploy(owner.address);
    await token.deployed();

    const DateTime = await ethers.getContractFactory("DateTime");
    const dt = await DateTime.deploy();
    await dt.deployed();

    const Hotel = await ethers.getContractFactory("Hotel");
    hotel = await Hotel.deploy(
      100,
      "0x8A753747A1Fa494EC9F6fE90FcF2E620c1d7C2B4",
      true
    );
    await hotel.deployed();
  });

  it("Should allow buying tokens and booking appointment", async function () {
    const price = await hotel.getEthPriceForTokens(2);
    await hotel.connect(addr1).buyTokens(2, { value: price.mul(2) });
    expect(await token.balanceOf(addr1.address)).to.equal(2);

    const timestamp = await hotel.getUnixTimestamp(12, 25, 2024);
    await hotel.connect(addr1).bookAppointment("Alice", timestamp, 2);
    const bookings = await hotel.getAppointmentsByUser(addr1.address);
    expect(bookings.length).to.equal(1);
  });
});