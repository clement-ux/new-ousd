// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OETH} from "../../src/OETH.sol";
import {Base} from "test/Base.sol";
import { Mainnet } from "test/Addresses.sol";

contract OETHScript is Base {
    bytes32 public constant SALT_DEPLOY_2 = 0;

    function deploy_2() public {
        // Internal logic can be added here if needed
        oeth = new OETH();
    }

    function deploy_2_id() public view returns (bytes32) {
        return keccak256(abi.encodePacked("OETHScript", block.chainid, SALT_DEPLOY_2));
    }

    function deploy_2_setAddresses() public {
        oeth = OETH(Mainnet.OETH);
    }
}
