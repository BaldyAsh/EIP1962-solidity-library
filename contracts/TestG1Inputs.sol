pragma solidity ^0.5.10;
pragma experimental ABIEncoderV2;

import {GenericEllipticCurve} from "../contracts/GenericEllipticCurve.sol";
import {CommonTypes} from "../contracts/CommonTypes.sol";
import {HelpersForTests} from "../contracts/HelpersForTests.sol";
import {PrebuildCurves} from "../contracts/PrebuildCurves.sol";
import {LengthsVerifier} from "../contracts/LengthsVerifier.sol";

contract TestG1Inputs {

    CommonTypes.CurveParams bls12_384_m_params;

    constructor() public {
        bls12_384_m_params = PrebuildCurves.bls12_384_m();
    }

    function testAddG1InputLengthsBLS12_384_M() public view returns (bool) {
        bytes memory p1 = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf49";
        bytes memory p2 = hex"02479e227b1762e5a8322ab109842fc1e481440020137ef6cd6282796bad37b95877281633289033017183acf2472e2b6c01851c8aab7868d17dc6bf38ba905a19ab8bcf308f1b417e833fa548f6a33afb4b91488d829cf924caeab5c09ad4593663";
        LengthsVerifier.verifyCorrectG1AddDataLengths(bls12_384_m_params, p1, p2);
        return true;
    }

    function testMulG1InputLengthsBLS12_384_M() public view returns (bool) {
        bytes memory p = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf49";
        bytes memory mul = hex"01a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
        LengthsVerifier.verifyCorrectG1MulDataLengths(bls12_384_m_params, p, mul);
        return true;
    }

    function testMultiExpG1InputLengthsBLS12_384_M() public view returns (bool) {
        uint8 numPairs = 3;
        bytes memory pairs = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
        LengthsVerifier.verifyCorrectG1MultiExpDataLengths(bls12_384_m_params, numPairs, pairs);
        return true;
    }

    function testFormAddG1InputBLS12_384_M() public view returns (bool) {
        bytes memory correctInput = hex"0131026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012103c192577dfb697d258e5f48f4c3f36bb518d0ea9b498ca3559dfb03a2c685a52900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4902479e227b1762e5a8322ab109842fc1e481440020137ef6cd6282796bad37b95877281633289033017183acf2472e2b6c01851c8aab7868d17dc6bf38ba905a19ab8bcf308f1b417e833fa548f6a33afb4b91488d829cf924caeab5c09ad4593663";
        bytes memory p1 = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf49";
        bytes memory p2 = hex"02479e227b1762e5a8322ab109842fc1e481440020137ef6cd6282796bad37b95877281633289033017183acf2472e2b6c01851c8aab7868d17dc6bf38ba905a19ab8bcf308f1b417e833fa548f6a33afb4b91488d829cf924caeab5c09ad4593663";
        (bytes memory input, uint _) = GenericEllipticCurve.formG1AddInput(bls12_384_m_params, p1, p2);
        return HelpersForTests.equal(input, correctInput);
    }

    function testFormMulG1InputBLS12_384_M() public view returns (bool) {
        bytes memory correctInput = hex"0231026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012103c192577dfb697d258e5f48f4c3f36bb518d0ea9b498ca3559dfb03a2c685a52900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
        bytes memory p = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf49";
        bytes memory mul = hex"01a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
        (bytes memory input, uint _) = GenericEllipticCurve.formG1MulInput(bls12_384_m_params, p, mul);
        return HelpersForTests.equal(input, correctInput);
    }

    function testFormMultiExpG1InputBLS12_384_M() public view returns (bool) {
        bytes memory correctInput = hex"0331026d331f7ce9cdc5e48d73aeedf0a1d7f7870b788046ec2aff712eda78d3fe42dfb8fe05c47ae860b05717583ae170045d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012103c192577dfb697d258e5f48f4c3f36bb518d0ea9b498ca3559dfb03a2c685a5290300b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
        uint8 numPairs = 3;
        bytes memory pairs = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
        (bytes memory input, uint _) = GenericEllipticCurve.formG1MultiExpInput(bls12_384_m_params, numPairs, pairs);
        return HelpersForTests.equal(input, correctInput);
    }
}