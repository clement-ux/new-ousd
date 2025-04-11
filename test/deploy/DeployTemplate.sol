// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Base} from "test/Base.sol";

abstract contract DeployTemplate is Base {
    struct GovernancePayload {
        address[] targets;
        uint256[] values;
        string[] signatures;
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

    event AddressSet(address _address);
}
