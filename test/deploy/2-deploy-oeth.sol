// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OETH} from "../../src/token/OETH.sol";
import {DeployTemplate} from "test/deploy/999-deploy.sol";
import {Mainnet} from "test/Addresses.sol";

contract OETHScript is DeployTemplate {
    bytes32 public constant SALT_DEPLOY_2 = 0;

    function deploy_2(DeployActions action) public returns (GovernancePayload memory gp) {
        if (action == DeployActions.Create) {
            _create_2();
        } else if (action == DeployActions.SetAddresses) {
            _setAddresses_2();
        } else if (action == DeployActions.Governance) {
            gp = _governance_2();
        } else if (action == DeployActions.Id) {
            gp = _scriptKey_2();
        }
    }

    function _create_2() internal {
        oeth = new OETH();
    }

    function _governance_2() internal view returns (GovernancePayload memory) {}

    function _scriptKey_2() internal view returns (GovernancePayload memory gp) {
        gp.scriptKey = keccak256(abi.encodePacked("OETHScript", block.chainid, SALT_DEPLOY_2));
    }

    function _setAddresses_2() internal {
        oeth = OETH(Mainnet.OETH);
        emit AddressSet(address(oeth));
    }
}
