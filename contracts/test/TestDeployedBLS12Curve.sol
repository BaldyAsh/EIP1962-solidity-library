pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

import {EllipticCurve} from "../EllipticCurve.sol";
import {CommonTypes} from "../CommonTypes.sol";
import {HelpersForTests} from "./HelpersForTests.sol";
import {PrebuildCurves} from "../PrebuildCurves.sol";

contract TestDeployedBLS12Curve {

    EllipticCurve bls12_384_m;

    constructor() public {
        bls12_384_m = new EllipticCurve(PrebuildCurves.bls12_384_m());
    }

    function getCurveParams() public view {
        bls12_384_m.getCurveParams();
    }

    function changeCurveParams(CommonTypes.CurveParams memory curveParams) public {
        bls12_384_m.changeCurveParams(curveParams);
    }

    function testAddG1() public view returns (bool) {
        bytes memory correctResult = hex"00bac7ab58397d69d40ee30088f44fc96e363794959408a688228799780aafb3fee41f5abf5b11e7e0add9e460624d41660194ef9a5adecd58f28b842a6a9bc451c76d8cb3f54891d273b5b515a8e1b06ddb917082016c114923b5ce1e8212fbabb1";
        bytes memory p1 = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf49";
        bytes memory p2 = hex"02479e227b1762e5a8322ab109842fc1e481440020137ef6cd6282796bad37b95877281633289033017183acf2472e2b6c01851c8aab7868d17dc6bf38ba905a19ab8bcf308f1b417e833fa548f6a33afb4b91488d829cf924caeab5c09ad4593663";
        bytes memory result = bls12_384_m.g1Add(p1, p2);
        return HelpersForTests.equal(result, correctResult);
    }

    // function testMulG1() public view returns (bool) {
    //     bytes memory correctResult = hex"2479e227b1762e5a8322ab109842fc1e481440020137ef6cd6282796bad37b95877281633289033017183acf2472e2b6c1851c8aab7868d17dc6bf38ba905a19ab8bcf308f1b417e833fa548f6a33afb4b91488d829cf924caeab5c09ad4593663";
    //     bytes memory p = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf49";
    //     bytes memory factor = hex"01a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
    //     bytes memory result = bls12_384_m.g1Mul(p, factor);
    //     return HelpersForTests.equal(result, correctResult);
    // }

    // function testMultiExpG1() public view returns (bool) {
    //     bytes memory correctResult = hex"2479e227b1762e5a8322ab109842fc1e481440020137ef6cd6282796bad37b95877281633289033017183acf2472e2b6c1851c8aab7868d17dc6bf38ba905a19ab8bcf308f1b417e833fa548f6a33afb4b91488d829cf924caeab5c09ad4593663";
    //     uint8 numPairs = 3;
    //     bytes memory pairs = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
    //     bytes memory result = bls12_384_m.g1MultiExp(numPairs, pairs);
    //     return HelpersForTests.equal(result, correctResult);
    // }

    // function testAddG2() public view returns (bool) {
    //     bytes memory correctResult = hex"004b6e56e5c05c0326653db28ee57c4155a8257dfe50695f14e5bb6c15113429f154aa5cd0a75a9b7db8b7d9c878a11515024e5f4800afc640288d68e5c9c2209795f8789465e0b0f49d1c047341cc61b52068eff7186db42de70eae178e6a08e75b0096d93f4253ae722fd5833f508110b4154a4ed440401174ddeaec89ac236a9b8bb325ac07253e64b18e8cce66ecac4c1f01c2721afe0cb38260be4cf450e317e4c60e191b3c98348aae52d7b906bb9eacbb99ea7064ccac70b63a6926794ff538ce";
    //     bytes memory p1 = hex"0101ffde193f98185f975ffb1372580fd7a93194e7a50a5cf7852f292455e0a34451c82bd7901a3de0c2a3479e716cbbdc00ac30a79956814c1a0e970fb255184f367d122abb6f3f9627ac2c2c97a68379d16883dfaf2549e3a3dce33f3bea1247df01460c7673ee5b7a2db0e9452d1b7fbb502e3f999f1b1dcd31e7062346408863c7f973b94e34c8b55c32bf5e829c664688005aa657b27ade7a8f4b1cabea24ce403f3ce23f7274e2569c90bcb97a4c04434c78438560cec76719bde389aedc170113";
    //     bytes memory p2 = hex"b496c3cbe37013741bd46bd014a14dac81f313a8223a8bc7c5e636ad4d5f8b53161f3518a47c220ed0bfe5139a95777c6d380a370d13539073153fc964680e0eaba50a5e4ecb4740c2af8c9cead6cefd12c4979577acc1542323477f98f02d74449321aaad1880956b33d3f9c1b4937e1105ae93c3bed0bd4cfd7340bba02801331245f90a64083cf57a2fc91293d0d172dc549af6c38cfb4df6e5ead8a9b129b51bc73fe32fea6a4947697e4e40c9827700dc5d8604b16885d8681fe0e0b0f90cf81aca";
    //     bytes memory result = bls12_384_m.g2Add(p1, p2);
    //     return HelpersForTests.equal(result, correctResult);
    // }

    // function testMulG2() public view returns (bool) {
    //     bytes memory correctResult = hex"004b6e56e5c05c0326653db28ee57c4155a8257dfe50695f14e5bb6c15113429f154aa5cd0a75a9b7db8b7d9c878a11515024e5f4800afc640288d68e5c9c2209795f8789465e0b0f49d1c047341cc61b52068eff7186db42de70eae178e6a08e75b0096d93f4253ae722fd5833f508110b4154a4ed440401174ddeaec89ac236a9b8bb325ac07253e64b18e8cce66ecac4c1f01c2721afe0cb38260be4cf450e317e4c60e191b3c98348aae52d7b906bb9eacbb99ea7064ccac70b63a6926794ff538ce";
    //     bytes memory p = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf49";
    //     bytes memory factor = hex"01a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
    //     bytes memory result = bls12_384_m.g2Mul(p, factor);
    //     return HelpersForTests.equal(result, correctResult);
    // }

    // function testMultiExpG2() public view returns (bool) {
    //     bytes memory correctResult = hex"004b6e56e5c05c0326653db28ee57c4155a8257dfe50695f14e5bb6c15113429f154aa5cd0a75a9b7db8b7d9c878a11515024e5f4800afc640288d68e5c9c2209795f8789465e0b0f49d1c047341cc61b52068eff7186db42de70eae178e6a08e75b0096d93f4253ae722fd5833f508110b4154a4ed440401174ddeaec89ac236a9b8bb325ac07253e64b18e8cce66ecac4c1f01c2721afe0cb38260be4cf450e317e4c60e191b3c98348aae52d7b906bb9eacbb99ea7064ccac70b63a6926794ff538ce";
    //     uint8 numPairs = 3;
    //     bytes memory pairs = hex"00b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc900b1d9d7d4e19966f41ed390530d41eebaaa1c707c3fb44303ae58df3c9e9c0589b4692a397ecdc90103df90ba78fb4a1c01af3190c07b6494b12dba8aae83c6f5a61251f82bdddcf4a00d0e8277cab9a7febdbbdb3f961ba3a2b38b9ad7a6a3cf4901a377718a6300d8dfa68b483f26b2d31c2501427bf56373224e9a7e9d15cabfc9";
    //     bytes memory result = bls12_384_m.g2MultiExp(numPairs, pairs);
    //     return HelpersForTests.equal(result, correctResult);
    // }

    // function testPairing() public view returns (bool) {
    //     bytes memory correctResult = hex"01";
    //     uint8 numPairs = 2;
    //     bytes memory pairs = hex"000ee7950a41f0c887ca93b20ca08a39440ae6e8ed83e01709611584526cecb777c3ab3b9ff9d3b88fbe108fc916396d8f009445fc17ee70f2b9e96db6d4225a9f577d78de557b1ac0fe47f629f93e3427fecf9fa176ff34d2c757004d1ea7b67aff007f5a068d5d9bc448cf9ce3d6fa287d1f01ec5c1ec86a5b2ae55b1c71d7a4281f83b4d2356613f3113bd858a41e9fb10900cdf67dfe485c8c42aeca5c2dac457ab1dfd98df8f19d09bb4a194fc4966418f84a218ead3d6100e567124ea5c106fb1b00399865a965906250a2cb48abd2e1653b41604f3aa2f376539940c4982a4f6f26bcb89bd58cda247bdb02a51636cc5e64024c816df1882a1c2829c6af47014157efb241de61aeaa06d3b8d89c0953ac1e94857c15f2497e0ea3eb6ff80362cb3c0b000ee7950a41f0c887ca93b20ca08a39440ae6e8ed83e01709611584526cecb777c3ab3b9ff9d3b88fbe108fc916396d8f01d8ed2364fb5cd32aa405f819ce4738a009929a2acbd16a012938b07f95ca1ae0e95e644d7bb38de900170b1c39b9895e007f5a068d5d9bc448cf9ce3d6fa287d1f01ec5c1ec86a5b2ae55b1c71d7a4281f83b4d2356613f3113bd858a41e9fb10900cdf67dfe485c8c42aeca5c2dac457ab1dfd98df8f19d09bb4a194fc4966418f84a218ead3d6100e567124ea5c106fb1b00399865a965906250a2cb48abd2e1653b41604f3aa2f376539940c4982a4f6f26bcb89bd58cda247bdb02a51636cc5e64024c816df1882a1c2829c6af47014157efb241de61aeaa06d3b8d89c0953ac1e94857c15f2497e0ea3eb6ff80362cb3c0b";
    //     bytes memory result = bls12_384_m.pairing(pairs, numPairs);
    //     return HelpersForTests.equal(result, correctResult);
    // }

}