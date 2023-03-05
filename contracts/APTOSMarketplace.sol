// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./APTOSNFT.sol" ;

contract APTOSMarketplace is Ownable {
    mapping(address => bool) private _team ;

    using Counters for Counters.Counter ;

    Counters.Counter nft_counter ;
    Counters.Counter nft_sold_counter ;

    enum MintStatus { Begin, OnMinting , Completed }

    struct nft {
        uint256 nft_id ;
        bool sold ;
    }

    APTOSNFT private APTOS_NFT ;

    MintStatus private mint_status = MintStatus.Begin ;
    uint256 private max_supply = 10000 ;
    uint256 private total_supply = 0;
    address private admin_addr = address(0) ;

    mapping(uint256 => nft) private nfts ;

    constructor( address _nft_addr ) {
        APTOS_NFT = APTOSNFT(_nft_addr) ;
        
        APTOS_NFT.installMarketplace(address(this));

        admin_addr = msg.sender ;
    }

    function mint(uint256 _amount) public onlyOwner {
        require(mint_status != MintStatus.OnMinting, "...On Minting");
        require(nft_counter.current() < max_supply, "Overflow Supply");

        mint_status = MintStatus.OnMinting;

        for(uint256 _tokenId = total_supply ; _tokenId < total_supply + _amount ; _tokenId++) {
            APTOS_NFT.mint(_tokenId);
                
            nfts[_tokenId] = nft(
                _tokenId,
                false
            );

            nft_counter.increment();
            if(nft_counter.current() > max_supply) {
                total_supply = max_supply ;
                mint_status = MintStatus.Completed ;
                return ;
            }
        }

        total_supply = total_supply + _amount ;

        mint_status = MintStatus.Begin ;
    }

    function isAdmin() public view returns(bool) {
        if(msg.sender == admin_addr) return true;

        return false;
    }

    function mintStatus() public view returns(MintStatus) {
        return mint_status ;
    }

    function totalSupply() public view returns(uint256) {
        return nft_counter.current() ;
    }

    function withdraw(address _to, uint256 _tokenId) public onlyOwner {
        nfts[_tokenId].sold = true ;

        nft_sold_counter.increment();

        APTOS_NFT.withdraw(_to, _tokenId);
    }

    function soldCount() public view returns(uint256) {
        return nft_sold_counter.current();
    }
}
