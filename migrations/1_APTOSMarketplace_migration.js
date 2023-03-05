const APTOSMarketplace = artifacts.require("APTOSMarketplace");
const APTOSNFT = artifacts.require("APTOSNFT") ;

module.exports = async function (deployer) {
  await deployer.deploy(APTOSNFT) ;

  const deployed_aptos_nft_contract = await APTOSNFT.deployed() ;

  console.log("APTOS NFT Address:", deployed_aptos_nft_contract.address) ;

  await deployer.deploy(
    APTOSMarketplace,
    deployed_aptos_nft_contract.address
  );

  const deployed_nefa_marketplace_contract =  await APTOSMarketplace.deployed() ;

  console.log("APTOS Marketplace Address:", deployed_nefa_marketplace_contract.address);
};