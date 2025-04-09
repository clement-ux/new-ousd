// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Base} from "test/Base.sol";

abstract contract DeployTemplate is Base {
    struct GovernancePayload {
        address[] targets;
        uint256[] values;
        bytes[] payloads;
        bytes32 predecessor;
        bytes32 salt;
        bytes32 scriptKey;
    }

    enum DeployActions {
        Create,
        SetAddresses,
        Governance,
        Id
    }

    //function _create() internal virtual {}
    //function _setAddresses() internal virtual {}
    //function _governance() internal virtual returns (GovernancePayload memory) {}
    //function _scriptKey() internal virtual returns (GovernancePayload memory gp) {}
}
