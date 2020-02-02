pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

import {GenericEllipticCurve} from "../contracts/GenericEllipticCurve.sol";
import {CommonTypes} from "../contracts/CommonTypes.sol";

contract EllipticCurve {

    // Current curve parameters
    CommonTypes.CurveParams private curveParams;

    // Contract creator
    address creator;

    // Constructor input is curve params.
    // If _curveType is Custom then curveType will be setted to Undefined.
    constructor(CommonTypes.CurveParams memory _curveParams) public {
        curveParams = _curveParams;
        creator = msg.sender;
    }

    // Only the elliptic curve contract creator can change curve params.
    function changeCurveParams(CommonTypes.CurveParams memory _curveParams) public {
        if (msg.sender != creator) return;

        curveParams = _curveParams;
    }

    // Get curve params
    function getCurveParams() public view returns (CommonTypes.CurveParams memory) {
        return curveParams;
    }

    // Compies the G1 Add operation result.
    // Params:
    // - lhs - first point's X and Y coordinates in G1Point struct representation
    // - rhs - second point's X and Y coordinates in G1Point struct representation
    // Returns the newly created bytes memory.
    function g1Add(
        bytes memory lhs,
        bytes memory rhs
    ) public view returns (bytes memory result) {
        (bytes memory input, uint256 outputLength) = GenericEllipticCurve.formG1AddInput(curveParams, lhs, rhs);
        result = GenericEllipticCurve.callEip1962(
            9,
            input,
            input.length,
            outputLength
        );
    }

    // Compies the G1 Mul operation result.
    // Params:
    // - lhs - first point's X and Y coordinates in G1Point struct representation
    // - rhs - sсalar multiplication factor in bytes
    // Returns the newly created bytes memory.
    function g1Mul(
        bytes memory lhs,
        bytes memory rhs
    ) public view returns (bytes memory result) {
        (bytes memory input, uint256 outputLength) = GenericEllipticCurve.formG1MulInput(curveParams, lhs, rhs);
        result = GenericEllipticCurve.callEip1962(
            9,
            input,
            input.length,
            outputLength
        );
    }

    // Compies the G1 Multiexponentiation operation result.
    // Params:
    // - numPairs - number of (point, scalar) pairs for multiexponentiation
    // - pointScalarPairs - (point, scalar) pairs for multiexponentiation
    // Returns the newly created bytes memory.
    function g1MultiExp(
        uint8 numPairs,
        bytes memory pointScalarPairs
    ) public view returns (bytes memory result) {
        (bytes memory input, uint256 outputLength) = GenericEllipticCurve.formG1MultiExpInput(curveParams, numPairs, pointScalarPairs);
        result = GenericEllipticCurve.callEip1962(
            9,
            input,
            input.length,
            outputLength
        );
    }

    // Compies the G2 Add operation result.
    // Params:
    // - lhs - first point's X and Y coordinates in G2Point struct representation
    // - rhs - second point's X and Y coordinates in G2Point struct representation
    // Returns the newly created bytes memory.
    function g2Add(
        bytes memory lhs,
        bytes memory rhs
    ) public view returns (bytes memory result) {
        (bytes memory input, uint256 outputLength) = GenericEllipticCurve.formG2AddInput(curveParams, lhs, rhs);
        result = GenericEllipticCurve.callEip1962(
            9,
            input,
            input.length,
            outputLength
        );
    }

    // Compies the G2 Mul operation result.
    // Params:
    // - lhs - first point's X and Y coordinates in G2Point struct representation
    // - rhs - sсalar multiplication factor in bytes
    // Returns the newly created bytes memory.
    function g2Mul(
        bytes memory lhs,
        bytes memory rhs
    ) public view returns (bytes memory result) {
        (bytes memory input, uint256 outputLength) = GenericEllipticCurve.formG2MulInput(curveParams, lhs, rhs);
        result = GenericEllipticCurve.callEip1962(
            9,
            input,
            input.length,
            outputLength
        );
    }

    // Compies the G2 Multiexponentiation operation result.
    // Params:
    // - numPairs - number of (point, scalar) pairs for multiexponentiation
    // - pointScalarPairs - (point, scalar) pairs for multiexponentiation
    // Returns the newly created bytes memory.
    function g2MultiExp(
        uint8 numPairs,
        bytes memory pointScalarPairs
    ) public view returns (bytes memory result) {
        (bytes memory input, uint256 outputLength) = GenericEllipticCurve.formG2MultiExpInput(curveParams, numPairs, pointScalarPairs);
        result = GenericEllipticCurve.callEip1962(
            9,
            input,
            input.length,
            outputLength
        );
    }

    // Verifies the correctness of the pairing operation parameters.
    // Params:
    // - pairs - point pairs array encoded as (G1 point, G2 point) in bytes
    // - numPairs - number of pairs as uint8
    // Returns:
    // If result of a pairing (element of Fp12) is equal to identity - return single byte 0x01, otherwise return 0x00 following the existing ABI for BN254 precompile.
    function pairing(
        bytes memory pairs,
        uint8 numPairs
    ) public view returns (bytes memory result) {
        bytes memory input;
        uint256 outputLength;
        // Currently pairing is available only for BLS12 curve family
        if (curveParams.curveType == 0x01) {
            (input, outputLength) = GenericEllipticCurve.formBLS12PairingInput(curveParams, pairs, numPairs);
        }
        result = GenericEllipticCurve.callEip1962(
            9,
            input,
            input.length,
            outputLength
        );
    }

}