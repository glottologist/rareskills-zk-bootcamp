// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

library EC {

struct Point {
	uint256 x;
	uint256 y;
}

    uint256 constant MOD = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    uint256 constant ORD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    uint256 constant INV = ORD-2;

 function areEqual(Point memory p1, Point memory p2) internal pure returns (bool) {
        return p1.x == p2.x && p1.y == p2.y;
    }
    function isOnCurve(Point memory P) internal pure returns (bool) {

	    //(y^2 == x^3 + 3) % p
	    uint left = mulmod(P.y,P.y, MOD);
	    uint right = addmod(mulmod(mulmod(P.x, P.x, MOD), P.x, MOD), 3, MOD);
	    
	    return (left == right);
	}

 function negate(Point memory p) internal pure returns (Point memory) {
     if(p.x == 0 && p.y == 0){
         return Point(0,0);
    } else {
         return Point(p.x,MOD - (p.y%MOD));

    }
 }


    function add(Point memory p1, Point memory p2) internal view returns (Point memory result) {
        uint256[4] memory input = [p1.x, p1.y, p2.x, p2.y];
        bool succeeded;

        assembly {
            succeeded := staticcall(gas(), 0x06, input, 0xc0, result, 0x60) 
        }

         require(succeeded,"(EC) Point addtion failed");
        
    }

function multiply(Point memory p, uint256 scalar) internal view returns (Point memory result) {
        uint256[3] memory input = [p.x, p.y, scalar];
        bool succeeded;

        assembly {
            succeeded := staticcall(gas(), 0x07, input, 0x80, result, 0x60) 
        }
        
        require(succeeded,"(EC) Point scalar multiplication failed");

    }

}
