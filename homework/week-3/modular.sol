// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

library M {
 function modExp(uint256 base, uint256 exponent, uint256 modulus) internal view returns (uint256 output) {

        bool succeeded;

        assembly {
            let input := mload(0x40)
            mstore(input, 0x20)             // Length of Base
            mstore(add(input, 0x20), 0x20)  // Length of Exponent
            mstore(add(input, 0x40), 0x20)  // Length of Modulus
            mstore(add(input, 0x60), base)  // Base
            mstore(add(input, 0x80), exponent)     // Exponent
            mstore(add(input, 0xa0), modulus)     // Modulusp := mload(0x40)
            succeeded := staticcall(sub(gas(),2000), 0x05, input, 0xc0, output,0x20)
        }

        // Revert if the call to the precompiled contract was unsuccessful
        require(succeeded, "Modular exponentiation failed.");

    }
}

