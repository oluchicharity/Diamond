// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {ERC721Facet} from "./ERC721Facet.sol";

contract PresaleFacet {
    uint256 public constant NFT_PRICE = 0.0333 ether; // 1 ETH = 30 NFTs
    ERC721Facet private erc721Facet;

    constructor(address _erc721Facet) {
        erc721Facet = ERC721Facet(_erc721Facet);
    }

    function buyNFT() external payable {
        require(msg.value >= NFT_PRICE, "Insufficient ETH sent");
        uint256 numberOfTokens = (msg.value * 30) / 1 ether; 

        for (uint256 i = 0; i < numberOfTokens; i++) {
            erc721Facet.mint(msg.sender); 
    }
    }
    }
