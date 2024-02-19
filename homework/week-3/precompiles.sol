// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "./ec.sol";
import "./modular.sol";

function rationalAdd(EC.Point calldata A, EC.Point calldata B, uint256 num, uint256 den) view returns (bool verified) {
    uint256 invmod = M.modExp(den,EC.INV,EC.ORD);

     require(invmod * den == 1,"Modular inverse is incorrect");

    uint256 q = mulmod(num,invmod,EC.ORD);

    EC.Point memory C = EC.add(A,B);

    require(EC.isOnCurve(C), "A*B is not on curve");

    EC.Point memory D = EC.multiply(EC.Point(1,2), q);

    require(EC.isOnCurve(C), "A*B is not on curve");
    
    return EC.areEqual(C,D);

}
