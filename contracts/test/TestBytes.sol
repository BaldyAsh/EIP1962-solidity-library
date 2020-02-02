pragma solidity ^0.5.8;

import {Bytes} from "../Bytes.sol";
import {HelpersForTests} from "./HelpersForTests.sol";

contract TestBytes {

    function testEqual() public pure returns (bool) {
        return HelpersForTests.equal(hex"00aaff", hex"00aaff");
    }

    function testNotEqual() public pure returns (bool) {
        return HelpersForTests.equal(hex"00aaf1", hex"00aaff");
    }

    function testToBytesFromUInt8Correct() public pure returns (bool) {
        return HelpersForTests.equal(
            Bytes.toBytesFromUInt8(128),
            hex"80"
        );
    }

    function testToBytesFromUInt8NotCorrect() public pure returns (bool) {
        return HelpersForTests.equal(
            Bytes.toBytesFromUInt8(128),
            hex"81"
        );
    }

    function testConcatEqual() public pure returns (bool) {
        return HelpersForTests.equal(
            Bytes.concat(hex"0282", hex"12f2"),
            hex"028212f2"
        );
    }

    function testConcatNotEqual() public pure returns (bool) {
        return HelpersForTests.equal(
            Bytes.concat(hex"0282", hex"12f2"),
            hex"018212f2"
        );
    }
}