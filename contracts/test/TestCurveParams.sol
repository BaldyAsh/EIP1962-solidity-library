pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

import {GenericEllipticCurve} from "../GenericEllipticCurve.sol";
import {CommonTypes} from "../CommonTypes.sol";
import {HelpersForTests} from "./HelpersForTests.sol";
import {PrebuildCurves} from "../PrebuildCurves.sol";
import {LengthsVerifier} from "../LengthsVerifier.sol";

contract TestCurveParams {

    CommonTypes.CurveParams bls12_384_m_params;

    constructor() public {
        bls12_384_m_params = PrebuildCurves.bls12_384_m();
    }

    function testCurveParamsLengthsBLS12_384_M() public view returns (bool) {
        LengthsVerifier.verifyCorrectCurveParamsLengthsForG1Op(bls12_384_m_params);
        LengthsVerifier.verifyCorrectCurveParamsLengthsForG2Op(bls12_384_m_params);
        LengthsVerifier.verifyCorrectBLS12CurveParamsLengthsForPairingOp(bls12_384_m_params);
        return true;
    }

    function testG1OpDataBLS12_384_M() public view returns (bool) {
        bytes memory opData = GenericEllipticCurve.getG1OpDataInBytes(bls12_384_m_params);
        bytes memory correctOpData = hex"31026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012103c192577dfb697d258e5f48f4c3f36bb518d0ea9b498ca3559dfb03a2c685a529";
        return HelpersForTests.equal(opData, correctOpData);
    }

    function testG2OpDataBLS12_384_M() public view returns (bool) {
        bytes memory opData = GenericEllipticCurve.getG2OpDataInBytes(bls12_384_m_params);
        bytes memory correctOpData = hex"31026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045d02026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012103c192577dfb697d258e5f48f4c3f36bb518d0ea9b498ca3559dfb03a2c685a529";
        return HelpersForTests.equal(opData, correctOpData);
    }

    function testPairingOpDataBLS12_384_M() public view returns (bool) {
        bytes memory opData = GenericEllipticCurve.getBLS12PairingOpDataInBytes(bls12_384_m_params);
        bytes memory correctOpData = hex"0131026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012103c192577dfb697d258e5f48f4c3f36bb518d0ea9b498ca3559dfb03a2c685a529026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010109016463d0693ad8bbad00";
        return HelpersForTests.equal(opData, correctOpData);
    }
}