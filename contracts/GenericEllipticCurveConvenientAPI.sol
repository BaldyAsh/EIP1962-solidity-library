pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

import {GenericEllipticCurve} from "../contracts/GenericEllipticCurve.sol";
import {PrebuildCurves} from "../contracts/PrebuildCurves.sol";
import {CommonTypes} from "../contracts/CommonTypes.sol";

library GenericEllipticCurveConvenientAPI {

    function getParamsForCurve(CommonTypes.PrebuildCurveTypes curveType) internal pure returns (CommonTypes.CurveParams memory) {
        if (curveType == CommonTypes.PrebuildCurveTypes.BLS12_384_m) {
            return PrebuildCurves.bls12_384_m();
        }
        if (curveType == CommonTypes.PrebuildCurveTypes.BLS12_384_d) {
            return PrebuildCurves.bls12_384_d();
        }
        if (curveType == CommonTypes.PrebuildCurveTypes.BLS12_381_m) {
            return PrebuildCurves.bls12_381_m();
        }
        if (curveType == CommonTypes.PrebuildCurveTypes.BLS12_381_d) {
            return PrebuildCurves.bls12_381_d();
        }
    }

    // Compies the G1 Add operation result.
    // Params:
    // - curveType - prebuild curve type
    // - lhs - first point's X and Y coordinates in G1Point struct representation
    // - rhs - second point's X and Y coordinates in G1Point struct representation
    // Returns the newly created bytes memory.
    function g1Add(
        CommonTypes.PrebuildCurveTypes curveType,
        bytes memory lhs,
        bytes memory rhs
    ) internal view returns (bytes memory result) {
        CommonTypes.CurveParams memory curveParams = getParamsForCurve(curveType);
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
    // - curveType - prebuild curve type
    // - lhs - first point's X and Y coordinates in G1Point struct representation
    // - rhs - sсalar multiplication factor in bytes
    // Returns the newly created bytes memory.
    function g1Mul(
        CommonTypes.PrebuildCurveTypes curveType,
        bytes memory lhs,
        bytes memory rhs
    ) internal view returns (bytes memory result) {
        CommonTypes.CurveParams memory curveParams = getParamsForCurve(curveType);
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
    // - curveType - prebuild curve type
    // - numPairs - number of (point, scalar) pairs for multiexponentiation
    // - pointScalarPairs - (point, scalar) pairs for multiexponentiation
    // Returns the newly created bytes memory.
    function g1MultiExp(
        CommonTypes.PrebuildCurveTypes curveType,
        uint8 numPairs,
        bytes memory pointScalarPairs
    ) internal view returns (bytes memory result) {
        CommonTypes.CurveParams memory curveParams = getParamsForCurve(curveType);
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
    // - curveType - prebuild curve type
    // - lhs - first point's X and Y coordinates in G2Point struct representation
    // - rhs - second point's X and Y coordinates in G2Point struct representation
    // Returns the newly created bytes memory.
    function g2Add(
        CommonTypes.PrebuildCurveTypes curveType,
        bytes memory lhs,
        bytes memory rhs
    ) internal view returns (bytes memory result) {
        CommonTypes.CurveParams memory curveParams = getParamsForCurve(curveType);
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
    // - curveType - prebuild curve type
    // - lhs - first point's X and Y coordinates in G2Point struct representation
    // - rhs - sсalar multiplication factor in bytes
    // Returns the newly created bytes memory.
    function g2Mul(
        CommonTypes.PrebuildCurveTypes curveType,
        bytes memory lhs,
        bytes memory rhs
    ) internal view returns (bytes memory result) {
        CommonTypes.CurveParams memory curveParams = getParamsForCurve(curveType);
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
    // - curveType - prebuild curve type
    // - numPairs - number of (point, scalar) pairs for multiexponentiation
    // - pointScalarPairs - (point, scalar) pairs for multiexponentiation
    // Returns the newly created bytes memory.
    function g2MultiExp(
        CommonTypes.PrebuildCurveTypes curveType,
        uint8 numPairs,
        bytes memory pointScalarPairs
    ) internal view returns (bytes memory result) {
        CommonTypes.CurveParams memory curveParams = getParamsForCurve(curveType);
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
    // - curveType - prebuild curve type
    // - pairs -  point pairs array encoded as (G1 point, G2 point) in bytes
    // Returns:
    // If result of a pairing (element of Fp12) is equal to identity - return single byte 0x01, otherwise return 0x00 following the existing ABI for BN254 precompile.
    function pairing(
        CommonTypes.PrebuildCurveTypes curveType,
        bytes memory pairs,
        uint8 numPairs
    ) internal view returns (bytes memory result) {
        CommonTypes.CurveParams memory curveParams = getParamsForCurve(curveType);
        if (curveParams.curveType == 0x01) {
            (bytes memory input, uint256 outputLength) = GenericEllipticCurve.formBLS12PairingInput(curveParams, pairs, numPairs);
            result = GenericEllipticCurve.callEip1962(
                9,
                input,
                input.length,
                outputLength
            );
        }
    }

}