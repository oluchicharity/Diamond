import { MerkleTree } from 'merkletreejs';
import keccak256 from 'keccak256';

const whitelist = [
    "0xf24A01aE29Dec4629DFB4170647C4eD4EFc392cD", 
    "0xf24A01aE29Dec4629DFB4170647C4eD4EFc392cD", 
    
];

// Hash addresses
const leafNodes = whitelist.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

// Merkle root
const root = merkleTree.getRoot().toString('hex');
console.log('Merkle Root:', root);

// Generate proof for a specific address
const claimingAddress = keccak256("0xf24A01aE29Dec4629DFB4170647C4eD4EFc392cD");
const hexProof = merkleTree.getHexProof(claimingAddress);
console.log('Proof for address:', hexProof);
