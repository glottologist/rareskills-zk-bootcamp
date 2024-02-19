struct ECPoint {
	uint256 x;
	uint256 y;
}

function rationalAdd(ECPoint calldata A, ECPoint calldata B, uint256 num, uint256 den) public view returns (bool verified) {
	
	// return true if the prover knows two numbers that add up to num/den
    uint256[4] memory input;
}
