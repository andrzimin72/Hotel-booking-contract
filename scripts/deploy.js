async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy DateTime
  const DateTime = await ethers.getContractFactory("DateTime");
  const dateTime = await DateTime.deploy();
  await dateTime.deployed();
  console.log("DateTime deployed to:", dateTime.address);

  // Deploy BookingToken
  const BookingToken = await ethers.getContractFactory("BookingToken");
  const bookingToken = await BookingToken.deploy(deployer.address);
  await bookingToken.deployed();
  console.log("BookingToken deployed to:", bookingToken.address);

  // Deploy Hotel
  const Hotel = await ethers.getContractFactory("Hotel");
  const hotel = await Hotel.deploy(
    100, // token price in USD
    "0x8A753747A1Fa494EC9F6fE90FcF2E620c1d7C2B4", // Chainlink ETH/USD Aggregator on Rinkeby
    true // useFixedPricing
  );
  await hotel.deployed();
  console.log("Hotel deployed to:", hotel.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
