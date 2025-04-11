// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OETH} from "../../src/token/OETH.sol";
import {DeployTemplate} from "test/deploy/DeployTemplate.sol";
import {Mainnet} from "test/Addresses.sol";

contract Script_002 is DeployTemplate {
    bytes32 public constant SALT_DEPLOY_2 = 0;

    function deploy_2(DeployActions action) public returns (GovernancePayload memory gp) {
        if (action == DeployActions.Create) {
            _create_2();
        } else if (action == DeployActions.SetAddresses) {
            _setAddresses_002();
        } else if (action == DeployActions.Governance) {
            gp = _governance_002();
        } else if (action == DeployActions.Id) {
            gp = _scriptKey_002();
        }
    }

    function _create_2() internal {
        oeth = new OETH();
    }

    function _governance_002() internal view returns (GovernancePayload memory) {}

    function _scriptKey_002() internal view returns (GovernancePayload memory gp) {
        gp.scriptKey = keccak256(abi.encodePacked("Script_002", block.chainid, SALT_DEPLOY_2));
    }

    function _setAddresses_002() internal {
        oeth = OETH(Mainnet.OETH);
        emit AddressSet(address(oeth));
    }
}
