// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSD} from "../../src/OUSD.sol";
import {Base} from "test/Base.sol";
import {Mainnet} from "test/Addresses.sol";

contract OUSDScript is Base {
    bytes32 public constant SALT_DEPLOY_1 = 0;

    function deploy_1() internal {
        // Internal logic can be added here if needed
        ousd = new OUSD();
    }

    function deploy_1_governance() internal {
        // Internal logic can be added here if needed
    }

    function deploy_1_id() internal view returns (bytes32) {
        return keccak256(abi.encodePacked("OUSDScript", block.chainid, SALT_DEPLOY_1));
    }

    function deploy_1_setAddresses() public {
        ousd = OUSD(Mainnet.OUSD);
    }
}
