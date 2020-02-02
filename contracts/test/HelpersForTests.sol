pragma solidity ^0.5.8;

library HelpersForTests {

    // Original: https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/AssertBytes.sol#L29
    // Function: equal(bytes memory, bytes memory)
    // Assert that two tightly packed bytes arrays are equal.
    // Params:
    //     A (bytes) - The first bytes.
    //     B (bytes) - The second bytes.
    //     message (string) - A message that is sent if the assertion fails.
    // Returns:
    //     result (bool) - The result.
    function equal(bytes memory _a, bytes memory _b) internal pure returns (bool) {
        bool returnBool = true;

        assembly {
            let length := mload(_a)

            // if lengths don't match the arrays are not equal
            switch eq(length, mload(_b))
            case 1 {
                // cb is a circuit breaker in the for loop since there's
                //  no said feature for inline assembly loops
                // cb = 1 - don't breaker
                // cb = 0 - break
                let cb := 1

                let mc := add(_a, 0x20)
                let end := add(mc, length)

                for {
                    let cc := add(_b, 0x20)
                // the next line is the loop condition:
                // while(uint(mc < end) + cb == 2)
                } eq(add(lt(mc, end), cb), 2) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    // if any of these checks fails then arrays are not equal
                    if iszero(eq(mload(mc), mload(cc))) {
                        // unsuccess:
                        returnBool := 0
                        cb := 0
                    }
                }
            }
            default {
                // unsuccess:
                returnBool := 0
            }
        }

        return returnBool;
    }
}