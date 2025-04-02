// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Init} from "../../Init.sol";

contract OUSDTest is Init {
    function test_setNumber() public {
        uint256 newNumber = 42;
        ousd.setNumber(newNumber);
        assertEq(ousd.number(), newNumber);
        oeth.setNumber(newNumber +1);
    }
}
