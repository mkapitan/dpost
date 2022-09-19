// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Decentrapost is ERC721, ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    // Fees associated with every post.
    
    uint256 public fees;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 fees_
    ) ERC721(name_, symbol_) {
        fees = fees_;
    }


    function safeMint(address to, string memory uri) public payable {

        require(msg.value >= fees, "Not enough ETH");
        payable(owner()).transfer(fees);

        // NFT Mint Post

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        // Check contract balance and return oversupplied fees to the caller.

        uint256 contractBalance = address(this).balance;

        if (contractBalance > 0) {
            payable(msg.sender).transfer(address(this).balance);
        }

    }

    // Override Functions

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage) 
        {
            super._burn(tokenId);
        }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
        {
            return super.tokenURI(tokenId);
        }

}