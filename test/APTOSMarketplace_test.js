const APTOSMarketplace = artifacts.require('./APTOSMarketplace.sol') ;
const APTOSNFT = artifacts.require('./APTOSNFT.sol') ;

const ethers = require('ethers') ;
const truffleAssert = require('truffle-assertions') ;

require('chai')
    .use(require('chai-as-promised'))
    .should() ;

contract('Marketplace Contract', async () => {
    let nftMarketplace ;
    let aptosNFT ;
    let test_attacker = '0xC7573d8217d818f9373cb77713f6f9A2eA972a3a';

    before(async () => {
        aptosNFT = await APTOSNFT.deployed() ;

        nftMarketplace = await APTOSMarketplace.deployed([
            aptosNFT.address
        ]);
    });

    it("APTOS Marketplace: addTeamMember", async () => {
        await truffleAssert.reverts(
            await nftMarketplace.addTeamMember(test_attacker, { from : test_attacker}),
            "caller is not team member"
        )
    }) ;

    it("APTOS NFT: installMarketplace", async () => {
        await truffleAssert.reverts(
            await aptosNFT.installMarketplace(test_attacker, { from : test_attacker }),
            "marketplace have already installed"
        )
    });

    it("APTOS NFT: mint", async () => {
        await truffleAssert.reverts(
            await aptosNFT.mint(0, "QmNs2LAXUbxyZrN285wPrp2k4tz1g3QAiNkfiKx3VRUXRt", { from : test_attacker }),
            "call is not owner"
        )
    });

    it('APTOS Marketplace' , async() => {
        console.log('\n');

        let new_memeber = '0xC7573d8217d818f9373cb77713f6f9A2eA972a3a' ;

        await nftMarketplace.addTeamMember(new_memeber) ;

        await nftMarketplace.mint('Gil #1', "Tanked Gil Schoolies", "QmNs2LAXUbxyZrN285wPrp2k4tz1g3QAiNkfiKx3VRUXRt") ;

        let buyer ='0x07dc07069071F313fE47AE20eCDD8DE7abA64C00' ;

        let old_owner_of_0 = await aptosNFT.ownerOf(0) ;
        console.log('\tOld owner of Gil #1: ', old_owner_of_0) ;
        
        await nftMarketplace.withdraw(buyer, 0) ;

        let new_owner_of_0 = await aptosNFT.ownerOf(0) ;
        console.log('\tNew owner of Gil #1: ', new_owner_of_0) ;

        let totalSupply = await nftMarketplace.totalSupply() ;

        console.log('\tTotal Supply:' , totalSupply.toString()) ;
    })
});