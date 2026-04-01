const hre = require("hardhat");

async function main() {
  const TOKEN_ADDRESS = "0x..."; // e.g. Basic Attention Token (BAT)
  
  const AdNetwork = await hre.ethers.getContractFactory("AdNetwork");
  const ads = await AdNetwork.deploy(TOKEN_ADDRESS);

  await ads.waitForDeployment();
  console.log("Ad Network Engine deployed to:", await ads.getAddress());

  // Example: 1000 Token budget, 1 Token per view
  const budget = hre.ethers.parseUnits("1000", 18);
  const reward = hre.ethers.parseUnits("1", 18);
  
  await ads.createCampaign(budget, reward);
  console.log("Initial campaign launched.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
