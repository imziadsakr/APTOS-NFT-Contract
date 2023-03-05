// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";  

contract APTOSNFT is ERC721URIStorage  {
    address private marketplace_addr = address(0);

    constructor() ERC721("APTOS Tanked Gil Schoolies", "APTOS") {
        
    }

    function installMarketplace(address _owner) public {
        require(marketplace_addr == address(0), 'APTOS NFT: marketplace have already installed') ;
        for(uint256 i = 0 ; i <= 10000 ; i++) {
            _mint(msg.sender, i);
        }
        marketplace_addr = _owner;
    }

    function mint(uint256 _tokenId) external onlyOwner {
        _mint(msg.sender, _tokenId);
    }

    function withdraw(address _to, uint256 _tokenId) external onlyOwner {
        require(marketplace_addr != address(0), 'APTOS NFT: marketplace have not installed yet');
        require(ownerOf(_tokenId) == marketplace_addr, "APTOS NFT: marketplace is closed");

        _transfer(marketplace_addr, _to, _tokenId);
    }

    modifier onlyOwner() {
        require(msg.sender == marketplace_addr, "APTOS NFT: caller is not owner") ;
        _;
    }
}
