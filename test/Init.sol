// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Deploys} from "./deploy/0-core.sol";
import {DeploymentTimestamp} from "script/DeploymentTimestamp.sol";

contract Init is Deploys {
    uint256 private _originalTimestamp;

    function setUp() public {
        deploymentTimestamp = new DeploymentTimestamp();

        vm.createSelectFork("https://eth.llamarpc.com", vm.envUint("MAINNER_FORK_BLOCK_NUMBER"));

        // Process governance
        _manageScripts();
    }

    function _manageScripts() internal {
        _originalTimestamp = block.timestamp;

        _deployOrSet(deploy_1, deploy_1_setAddresses, deploy_1_id);
        _deployOrSet(deploy_2, deploy_2_setAddresses, deploy_2_id);
    }

    function _deployOrSet(
        function () internal deploy,
        function () internal setAddress,
        function () internal view returns (bytes32) id
    ) internal {
        uint256 ts = deploymentTimestamp.deploymentTimestamps(id());
        if (ts == 0 || ts > _originalTimestamp) {
            deploy();
        } else {
            setAddress();
        }
    }
}
