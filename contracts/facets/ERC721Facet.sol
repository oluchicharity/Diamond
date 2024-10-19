// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";

contract ERC721Facet is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("LULUNFT", "LNFT") {}

    function mint(address to) external {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function balanceOf(address owner) external view returns (uint256) {
        return super.balanceOf(owner);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // Implement your token URI logic
        return string(abi.encodePacked("https://api.yourdomain.com/metadata/", uint2str(tokenId)));
    }

    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
