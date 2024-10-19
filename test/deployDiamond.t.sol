// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/Diamond.sol";
import "../contracts/facets/ERC721Facet.sol";
import "../contracts/facets/MerkleFacet.sol";
import "../contracts/facets/PresaleFacet.sol";

import "./helpers/DiamondUtils.sol";

contract DiamondDeployer is DiamondUtils, IDiamondCut {
    // Contract types for facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    ERC721Facet erc721F;
    MerkleFacet merkleF;
    PresaleFacet presaleF;

    function testDeployDiamond() public {
        // Deploy DiamondCutFacet and Diamond
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        
        // Deploy other facets
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        erc721F = new ERC721Facet();
        merkleF = new MerkleFacet();
        presaleF = new PresaleFacet(address(erc721F));

        // Prepare the cut struct to upgrade the diamond
        FacetCut;

        // DiamondLoupeFacet
        cut[0] = FacetCut({
            facetAddress: address(dLoupe),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondLoupeFacet")
        });

        // OwnershipFacet
        cut[1] = FacetCut({
            facetAddress: address(ownerF),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("OwnershipFacet")
        });

        // ERC721Facet
        cut[2] = FacetCut({
            facetAddress: address(erc721F),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("ERC721Facet")
        });

        // MerkleFacet
        cut[3] = FacetCut({
            facetAddress: address(merkleF),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("MerkleFacet")
        });

        // PresaleFacet
        cut[4] = FacetCut({
            facetAddress: address(presaleF),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("PresaleFacet")
        });

        // Upgrade the diamond with facets
        IDiamondCut(address(diamond)).diamondCut(cut, address(0), "");

        // Test interactions with the facets

        // Example of testing ERC721Facet minting
        ERC721Facet(address(diamond)).mint(address(this), 1);
        assert(ERC721Facet(address(diamond)).balanceOf(address(this)) == 1);

        // Example of testing PresaleFacet (buyNFT)
        uint256 valueSent = 0.05 ether;
        uint256 expectedTokens = (valueSent * 30) / 1 ether;
        PresaleFacet(address(diamond)).buyNFT{value: valueSent}();
        assert(ERC721Facet(address(diamond)).balanceOf(address(this)) == expectedTokens + 1);

        // Example of testing MerkleFacet (claim functionality)
        bytes32 merkleRoot = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;  // Add your real Merkle root
        MerkleFacet(address(diamond)).setMerkleRoot(merkleRoot);
        
        bytes32;
        proof[0] = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;  // Add a valid Merkle proof

        MerkleFacet(address(diamond)).claim(proof);
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
}
