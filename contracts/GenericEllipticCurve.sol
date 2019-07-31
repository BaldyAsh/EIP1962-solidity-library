pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

import {Bytes} from "../contracts/Bytes.sol";
import {CommonTypes} from "../contracts/CommonTypes.sol";

library GenericEllipticCurve {

    // MARK: - Supported operations with codes
    uint8 private constant OPERATION_G1_ADD = 0x01;
    uint8 private constant OPERATION_G1_MUL = 0x02;
    uint8 private constant OPERATION_G1_MULTIEXP = 0x03;
    uint8 private constant OPERATION_G2_ADD = 0x04;
    uint8 private constant OPERATION_G2_MUL = 0x05;
    uint8 private constant OPERATION_G2_MULTIEXP = 0x06;
    uint8 private constant OPERATION_PAIRING = 0x07;

    // Compies G1 point into a new bytes memory.
    // Returns the newly created bytes memory.
    function g1PointToBytes(CommonTypes.G1Point memory point, uint pointLength) private pure returns (bytes memory result) {
        result = Bytes.toBytesFromUInt(point.X, pointLength/2);
        result = Bytes.concat(result, Bytes.toBytesFromUInt(point.Y, pointLength/2));
    }

    // Compies G2 point into a new bytes memory.
    // Returns the newly created bytes memory.
    function g2PointToBytes(CommonTypes.G2Point memory point, uint pointLength) private pure returns (bytes memory result) {
        result = Bytes.toBytesFromUInt(point.X[0], pointLength/4);
        result = Bytes.concat(result, Bytes.toBytesFromUInt(point.X[1], pointLength/4));
        result = Bytes.concat(result, Bytes.toBytesFromUInt(point.Y[0], pointLength/4));
        result = Bytes.concat(result, Bytes.toBytesFromUInt(point.Y[1], pointLength/4));
    }

    // Compies points pair into a new bytes memory.
    // Returns the newly created bytes memory.
    function pairToBytes(
        CommonTypes.Pair memory pair,
        uint g1PointLength,
        uint g2PointLength) private pure returns (bytes memory result) {
        result = g1PointToBytes(pair.g1p, g1PointLength);
        result = Bytes.concat(result, g2PointToBytes(pair.g2p, g2PointLength));
    }

    // Compies points pairs array into a new bytes memory.
    // Returns the newly created bytes memory.
    function pairsArrayToBytes(
        CommonTypes.Pair[] memory pairs,
        uint g1PointLength,
        uint g2PointLength
    ) private pure returns (bytes memory result) {
        for (uint i = 0; i < pairs.length; i++) {
            result = Bytes.concat(result, pairToBytes(pairs[i], g1PointLength, g2PointLength));
        }
    }

    // Verifies the correctness of the curve parameters.
    function verifyCorrectCurveParamsLengths(CommonTypes.CurveParams memory params) private pure {
        require(params.baseFieldModulus.length == params.fieldLength, "baseFieldModulus should be equal to fieldLength");
        require(params.a.length == params.fieldLength, "a should be equal to fieldLength");
        require(params.b.length == params.fieldLength, "b should be equal to fieldLength");
        require(params.groupOrder.length == params.groupOrderLength, "groupOrder should be equal to groupOrderLength");
        require(params.baseFieldModulus.length == params.fieldLength, "baseFieldModulus should be equal to fieldLength");
        require(params.fpNonResidue.length == params.fieldLength, "fpNonResidue should be equal to fieldLength");
        require(params.mainSubgroupOrder.length == params.groupOrderLength, "mainSubgroupOrder should be equal to groupOrderLength");
        require(params.fp2NonResidue.length == params.fieldLength, "fp2NonResidue should be equal to fieldLength");
        require(params.fp6NonResidue.length == 2 * params.fieldLength, "fp6NonResidue should be equal to 2 * fieldLength");
        require(params.x.length == params.xLength, "x should be equal to xLength");
    }

    //
    // MARK: - G1 operations
    //

    // Verifies the correctness of the g1 add operation parameters.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in bytes
    // - rhs - second point's X and Y coordinates in bytes
    function verifyCorrectG1AddDataLengths(
        CommonTypes.CurveParams memory curveParams,
        bytes memory lhs,
        bytes memory rhs
    ) private pure {
        verifyCorrectCurveParamsLengths(curveParams);
        require(lhs.length == 2 * curveParams.fieldLength, "lhs should be equal to 2*fieldLength");
        require(rhs.length == 2 * curveParams.fieldLength, "rhs should be equal to 2*fieldLength");
    }

    // Verifies the correctness of the g1 mul operation parameters.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in bytes
    // - rhs - sсalar multiplication factor in bytes
    function verifyCorrectG1MulDataLengths(
        CommonTypes.CurveParams memory curveParams,
        bytes memory lhs,
        bytes memory rhs
    ) private pure {
        verifyCorrectCurveParamsLengths(curveParams);
        require(lhs.length == 2 * curveParams.fieldLength, "lhs should be equal to 2*fieldLength");
        require(rhs.length == curveParams.groupOrderLength, "rhs should be equal to groupOrderLength");
    }

    // Verifies the correctness of the g1 multi exp operation parameters.
    // Params:
    // - curveParams - curve parameters
    // - point -  point's X and Y coordinates in bytes
    // - scalar - sсalar order of exponentiation in bytes
    function verifyCorrectG1MultiExpDataLengths(
        CommonTypes.CurveParams memory curveParams,
        bytes memory point,
        bytes memory scalar
    ) private pure {
        verifyCorrectCurveParamsLengths(curveParams);
        require(point.length == 2 * curveParams.fieldLength, "point should be equal to 2*fieldLength");
        require(scalar.length == curveParams.groupOrderLength, "scalar should be equal to groupOrderLength");
    }

    // Compies the common prefix for all G1 operations based on curve parameters.
    // Returns the newly created bytes memory.
    function getG1OpDataInBytes(CommonTypes.CurveParams memory curveParams) private pure returns (bytes memory) {
        bytes memory opData = new bytes(2 + 3 * curveParams.fieldLength + curveParams.groupOrderLength);
        opData = Bytes.toBytesFromUInt8(curveParams.fieldLength);
        opData = Bytes.concat(opData, curveParams.baseFieldModulus);
        opData = Bytes.concat(opData, curveParams.a);
        opData = Bytes.concat(opData, curveParams.b);
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.groupOrderLength));
        opData = Bytes.concat(opData, curveParams.groupOrder);
        return opData;
    }

    // Compies the G1 Add operation result.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in G1Point struct representation
    // - rhs - second point's X and Y coordinates in G1Point struct representation
    // Returns: operation input and outputLength
    function formG1AddInput(
        CommonTypes.CurveParams memory curveParams,
        CommonTypes.G1Point memory lhs,
        CommonTypes.G1Point memory rhs
    ) public pure returns (bytes memory, uint) {

        bytes memory lhsBytes = g1PointToBytes(lhs, 2*curveParams.fieldLength);
        bytes memory rhsBytes = g1PointToBytes(rhs, 2*curveParams.fieldLength);

        verifyCorrectG1AddDataLengths(curveParams, lhsBytes, rhsBytes);

        bytes memory opData = getG1OpDataInBytes(curveParams);

        bytes memory input = new bytes(1 + opData.length + lhsBytes.length + rhsBytes.length);
        input = Bytes.toBytesFromUInt8(OPERATION_G1_ADD);
        input = Bytes.concat(input, opData);
        input = Bytes.concat(input, lhsBytes);
        input = Bytes.concat(input, rhsBytes);

        return (input, lhsBytes.length);
    }

    // Compies the G1 Mul operation result.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in G1Point struct representation
    // - rhs - sсalar multiplication factor in bytes
    // Returns: operation input and outputLength
    function formG1MulInput(
        CommonTypes.CurveParams memory curveParams,
        CommonTypes.G1Point memory lhs,
        bytes memory rhs
    ) public pure returns (bytes memory, uint) {

        bytes memory lhsBytes = g1PointToBytes(lhs, 2*curveParams.fieldLength);

        verifyCorrectG1MulDataLengths(curveParams, lhsBytes, rhs);

        bytes memory opData = getG1OpDataInBytes(curveParams);

        bytes memory input = new bytes(1 + opData.length + lhsBytes.length + rhs.length);
        input = Bytes.toBytesFromUInt8(OPERATION_G1_MUL);
        input = Bytes.concat(input, opData);
        input = Bytes.concat(input, lhsBytes);
        input = Bytes.concat(input, rhs);

        return (input, lhsBytes.length);
    }

    // Compies the G1 Multiexponentiation operation result.
    // Params:
    // - curveParams - curve parameters
    // - numPairs - number of (point, scalar) pairs for multiexponentiation
    // - point -  point's X and Y coordinates in G1Point struct representation
    // - scalar - sсalar order of exponentiation in bytes
    // Returns: operation input and outputLength
    function formG1MultiExpInput(
        CommonTypes.CurveParams memory curveParams,
        uint8 numPairs,
        CommonTypes.G1Point memory point,
        bytes memory scalar
    ) public pure returns (bytes memory, uint) {

        bytes memory pointBytes = g1PointToBytes(point, 2*curveParams.fieldLength);

        verifyCorrectG1MultiExpDataLengths(curveParams, pointBytes, scalar);

        bytes memory opData = getG1OpDataInBytes(curveParams);

        bytes memory input = new bytes(2 + opData.length + pointBytes.length + scalar.length);
        input = Bytes.toBytesFromUInt8(OPERATION_G1_MULTIEXP);
        input = Bytes.concat(input, opData);
        input = Bytes.concat(input, Bytes.toBytesFromUInt8(numPairs));
        input = Bytes.concat(input, pointBytes);
        input = Bytes.concat(input, scalar);

        return (input, pointBytes.length);
    }

    //
    // MARK: - G2 operations
    //

    // Verifies the correctness of the g2 add operation parameters.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in bytes
    // - rhs - second point's X and Y coordinates in bytes
    function verifyCorrectG2AddDataLengths(
        CommonTypes.CurveParams memory curveParams,
        bytes memory lhs,
        bytes memory rhs
    ) private pure {
        verifyCorrectCurveParamsLengths(curveParams);
        require(
            lhs.length == 2 * curveParams.extensionDegree * curveParams.fieldLength,
            "lhs should be equal to extensionDegree * fieldLength"
        );
        require(
            rhs.length == 2 * curveParams.extensionDegree * curveParams.fieldLength,
            "rhs should be equal to extensionDegree * fieldLength"
        );
    }

    // Verifies the correctness of the g2 mul operation parameters.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in bytes
    // - rhs - sсalar multiplication factor in bytes
    function verifyCorrectG2MulDataLengths(
        CommonTypes.CurveParams memory curveParams,
        bytes memory lhs,
        bytes memory rhs
    ) private pure {
        verifyCorrectCurveParamsLengths(curveParams);
        require(
            lhs.length == 2 * curveParams.extensionDegree * curveParams.fieldLength,
            "lhs should be equal to extensionDegree * fieldLength"
        );
        require(
            rhs.length == 2 * curveParams.groupOrderLength,
            "rhs should be equal to groupOrderLength"
        );
    }

    // Verifies the correctness of the g2 multi exp operation parameters.
    // Params:
    // - curveParams - curve parameters
    // - point -  point's X and Y coordinates in bytes
    // - scalar - sсalar order of exponentiation in bytes
    function verifyCorrectG2MultiExpDataLengths(
        CommonTypes.CurveParams memory curveParams,
        bytes memory point,
        bytes memory scalar
    ) private pure {
        verifyCorrectCurveParamsLengths(curveParams);
        require(
            point.length == 2 * curveParams.extensionDegree * curveParams.fieldLength,
            "lhs should be equal to extensionDegree * fieldLength"
        );
        require(
            scalar.length == 2 * curveParams.groupOrderLength,
            "rhs should be equal to groupOrderLength"
        );
    }

    // Compies the common prefix for all G2 operations based on curve parameters.
    // Returns the newly created bytes memory.
    function getG2OpDataInBytes(CommonTypes.CurveParams memory curveParams) private pure returns (bytes memory) {
        bytes memory opData = new bytes(3 + 4 * curveParams.fieldLength + curveParams.groupOrderLength);
        opData = Bytes.toBytesFromUInt8(curveParams.fieldLength);
        opData = Bytes.concat(opData, curveParams.baseFieldModulus);
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.extensionDegree));
        opData = Bytes.concat(opData, curveParams.fpNonResidue);
        opData = Bytes.concat(opData, curveParams.a);
        opData = Bytes.concat(opData, curveParams.b);
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.groupOrderLength));
        opData = Bytes.concat(opData, curveParams.groupOrder);
        return opData;
    }

    // Compies the G2 Add operation result.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in G2Point struct representation
    // - rhs - second point's X and Y coordinates in G2Point struct representation
    // Returns: operation input and outputLength
    function formG2AddInput(
        CommonTypes.CurveParams memory curveParams,
        CommonTypes.G2Point memory lhs,
        CommonTypes.G2Point memory rhs
    ) public pure returns (bytes memory, uint) {
        bytes memory lhsBytes = g2PointToBytes(lhs, 2*curveParams.extensionDegree*curveParams.fieldLength);
        bytes memory rhsBytes = g2PointToBytes(rhs, 2*curveParams.extensionDegree*curveParams.fieldLength);

        verifyCorrectG2AddDataLengths(curveParams, lhsBytes, rhsBytes);

        bytes memory opData = getG2OpDataInBytes(curveParams);

        bytes memory input = new bytes(1 + opData.length + lhsBytes.length + rhsBytes.length);
        input = Bytes.toBytesFromUInt8(OPERATION_G2_ADD);
        input = Bytes.concat(input, opData);
        input = Bytes.concat(input, lhsBytes);
        input = Bytes.concat(input, rhsBytes);

        return (input, lhsBytes.length);
    }

    // Compies the G2 Mul operation result.
    // Params:
    // - curveParams - curve parameters
    // - lhs - first point's X and Y coordinates in G2Point struct representation
    // - rhs - sсalar multiplication factor in bytes
    // Returns: operation input and outputLength.
    function formG2MulInput(
        CommonTypes.CurveParams memory curveParams,
        CommonTypes.G2Point memory lhs,
        bytes memory rhs
    ) public pure returns (bytes memory, uint) {
        bytes memory lhsBytes = g2PointToBytes(lhs, 2*curveParams.extensionDegree*curveParams.fieldLength);

        verifyCorrectG2MulDataLengths(curveParams, lhsBytes, rhs);

        bytes memory opData = getG2OpDataInBytes(curveParams);

        bytes memory input = new bytes(1 + opData.length + lhsBytes.length + rhs.length);
        input = Bytes.toBytesFromUInt8(OPERATION_G2_MUL);
        input = Bytes.concat(input, opData);
        input = Bytes.concat(input, lhsBytes);
        input = Bytes.concat(input, rhs);

        return (input, lhsBytes.length);
    }

    // Compies the G2 Multiexponentiation operation result.
    // Params:
    // - curveParams - curve parameters
    // - numPairs - number of (point, scalar) pairs for multiexponentiation
    // - point -  point's X and Y coordinates in G2Point struct representation
    // - scalar - sсalar order of exponentiation in bytes
    // Returns: operation input and outputLength.
    function formG2MultiExpInput(
        CommonTypes.CurveParams memory curveParams,
        uint8 numPairs,
        CommonTypes.G2Point memory point,
        bytes memory scalar
    ) public pure returns (bytes memory, uint) {
        bytes memory pointBytes = g2PointToBytes(point, 2*curveParams.extensionDegree*curveParams.fieldLength);

        verifyCorrectG2MultiExpDataLengths(curveParams, pointBytes, scalar);

        bytes memory opData = getG2OpDataInBytes(curveParams);

        bytes memory input = new bytes(2 + opData.length + pointBytes.length + scalar.length);
        input = Bytes.toBytesFromUInt8(OPERATION_G2_MULTIEXP);
        input = Bytes.concat(input, opData);
        input = Bytes.concat(input, Bytes.toBytesFromUInt8(numPairs));
        input = Bytes.concat(input, pointBytes);
        input = Bytes.concat(input, scalar);

        return (input, pointBytes.length);
    }

    // MARK: - Pairing operation

    // Verifies the correctness of the pairing operation parameters.
    // Params:
    // - curveParams - curve parameters
    // - pairs -  point pairs array encoded as (G1 point, G2 point) in bytes
    function verifyCorrectPairingPairsLengths(
        CommonTypes.CurveParams memory curveParams,
        bytes memory pairs,
        uint8 numPairs
    ) private pure {
        verifyCorrectCurveParamsLengths(curveParams);
        require(
            pairs.length == 6 * curveParams.fieldLength * numPairs,
            "pairs should be equal to 6 * fieldLength * numPairs"
        );
    }

    // Compies the common prefix for pairing operation based on curve parameters.
    // Returns the newly created bytes memory.
    function getPairingOpDataInBytes(CommonTypes.CurveParams memory curveParams) private pure returns (bytes memory) {
        bytes memory opData = new bytes(6 + 6 * curveParams.fieldLength + curveParams.groupOrderLength + curveParams.xLength);
        opData = Bytes.toBytesFromUInt8(curveParams.curveType);
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.fieldLength));
        opData = Bytes.concat(opData, curveParams.baseFieldModulus);
        opData = Bytes.concat(opData, curveParams.a);
        opData = Bytes.concat(opData, curveParams.b);
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.groupOrderLength));
        opData = Bytes.concat(opData, curveParams.mainSubgroupOrder);
        opData = Bytes.concat(opData, curveParams.fp2NonResidue);
        opData = Bytes.concat(opData, curveParams.fp6NonResidue);
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.twistType));
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.xLength));
        opData = Bytes.concat(opData, curveParams.x);
        opData = Bytes.concat(opData, Bytes.toBytesFromUInt8(curveParams.sign));
        return opData;
    }

    // Compies the pairing operation input and outputLength.
    // Params:
    // - curveParams - curve parameters
    // - pairs - point pairs encoded as (G1 point, G2 point) in CommonTypes.Pair struct representation
    // Returns: pairing input and outputLength
    function formPairingInput(
        CommonTypes.CurveParams memory curveParams,
        CommonTypes.Pair[] memory pairs
    ) public pure returns (bytes memory, uint) {
        uint8 numPairs = uint8(pairs.length);
        bytes memory pairsBytes = pairsArrayToBytes(pairs, 2*curveParams.fieldLength, 2*curveParams.extensionDegree*curveParams.fieldLength);

        verifyCorrectPairingPairsLengths(curveParams, pairsBytes, numPairs);

        bytes memory opData = getPairingOpDataInBytes(curveParams);

        bytes memory input = new bytes(2 + opData.length + pairsBytes.length);
        input = Bytes.toBytesFromUInt8(OPERATION_PAIRING);
        input = Bytes.concat(input, opData);
        input = Bytes.concat(input, Bytes.toBytesFromUInt8(numPairs));
        input = Bytes.concat(input, pairsBytes);

        return (input, 1);
    }

    // Compies the EIP-1962 contract static call result.
    // Params:
    // - input - operation input in bytes representation
    // - inputLength - operation input's bytes length
    // - outLength - operation output's bytes length
    // Returns: if result of a pairing (element of Fp12) is equal to identity
    //  - return single byte 0x01, otherwise return 0x00 following the existing ABI for BN254 precompile.
    function callEip1962(
        uint contractId,
        bytes memory input,
        uint inputLength,
        uint outLength
    ) public view returns (bytes memory result) {
        bytes memory out;
        assembly {
            result := staticcall(sub(gas, 2000), contractId, input, inputLength, out, outLength)
        }
    }
}
