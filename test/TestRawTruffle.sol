pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/TestRaw.sol";

contract TestRawTruffle {

    function testG1Add_BLS12_384_M() public {
        TestRaw test = TestRaw(DeployedAddresses.TestRaw());
        bool result = test.testG1Add_BLS12_384_M();
        Assert.equal(result, true, "testG1Add_BLS12_384_M failed");
    }

    function testG1Mul_BLS12_384_M() public {
        TestRaw test = TestRaw(DeployedAddresses.TestRaw());
        bool result = test.testG1Mul_BLS12_384_M();
        Assert.equal(result, true, "testG1Mul_BLS12_384_M failed");
    }

    function testG1Multiexp_BLS12_384_M() public {
        TestRaw test = TestRaw(DeployedAddresses.TestRaw());
        bool result = test.testG1Multiexp_BLS12_384_M();
        Assert.equal(result, true, "testG1Multiexp_BLS12_384_M failed");
    }

    function testG2Add_BLS12_384_M() public {
        TestRaw test = TestRaw(DeployedAddresses.TestRaw());
        bool result = test.testG2Add_BLS12_384_M();
        Assert.equal(result, true, "testG2Add_BLS12_384_M failed");
    }

    function testG2Mul_BLS12_384_M() public {
        TestRaw test = TestRaw(DeployedAddresses.TestRaw());
        bool result = test.testG2Mul_BLS12_384_M();
        Assert.equal(result, true, "testG2Mul_BLS12_384_M failed");
    }

    function testG2Multiexp_BLS12_384_M() public {
        TestRaw test = TestRaw(DeployedAddresses.TestRaw());
        bool result = test.testG2Multiexp_BLS12_384_M();
        Assert.equal(result, true, "testG2Multiexp_BLS12_384_M failed");
    }

    function testPairing_BLS12_384_M() public {
        TestRaw test = TestRaw(DeployedAddresses.TestRaw());
        bool result = test.testPairing_BLS12_384_M();
        Assert.equal(result, true, "testPairing_BLS12_384_M failed");
    }

}