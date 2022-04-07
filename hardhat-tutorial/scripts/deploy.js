const { ethers } = require("hardhat");

async function main() {
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so ChargingEVContract here is a factory for instances of our ChargingEV contract.
  */
  const ChargingEVContract = await ethers.getContractFactory("ChargingEV");

  // here we deploy the contract
  const deployedChargingEVContract = await ChargingEVContract.deploy();

  
  // Wait for it to finish deploying
  await deployedChargingEVContract.deployed();

  // print the address of the deployed contract
  console.log(
    "ChargingEV Contract Address:",
    deployedChargingEVContract.address
  );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });