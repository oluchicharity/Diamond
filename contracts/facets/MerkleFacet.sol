// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";

contract MerkleFacet {
    bytes32 public merkleRoot;

    function setMerkleRoot(bytes32 _merkleRoot) external {
        // Ensure only contract owner can set the Merkle root
        LibDiamond.enforceIsContractOwner();
        merkleRoot = _merkleRoot;
    }

    function claim(bytes32[] calldata proof) external {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(verify(proof, leaf), "Invalid proof");
        
        // Implement logic to mint an NFT to the claimer
        ERC721Facet(address(this)).mint(msg.sender);
    }

    function verify(bytes32[] memory proof, bytes32 leaf) internal view returns (bool) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = computedHash < proof[i] ? keccak256(abi.encodePacked(computedHash, proof[i])) : keccak256(abi.encodePacked(proof[i], computedHash));
        }
        return computedHash == merkleRoot;
    }
}
