// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Deploys} from "./deploy/0-core.sol";
import {DeploymentTimestamp} from "script/DeploymentTimestamp.sol";
import {TimelockController} from "@openzeppelin-4.6.0/contracts/governance/TimelockController.sol";
import {Mainnet} from "test/Addresses.sol";

contract Init is Deploys {
    uint256 private _originalTimestamp;

    function setUp() public {
        deploymentTimestamp = new DeploymentTimestamp();
        timelock = TimelockController(payable(Mainnet.TIMELOCK));

        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), vm.envUint("MAINNET_FORK_BLOCK_NUMBER"));

        // Process governance
        _manageScripts();
    }

    function _manageScripts() internal {
        _originalTimestamp = block.timestamp;

        _deployOrSet(deploy_1, deploy_1_setAddresses, deploy_1_governance, deploy_1_id);
        _deployOrSet(deploy_2, deploy_2_setAddresses, deploy_2_governance, deploy_2_id);
    }

    function _deployOrSet(
        function () internal deploy,
        function () internal setAddress,
        function () internal view returns (address[] memory, uint256[] memory, bytes[] memory, bytes32, bytes32)
            deployGovernance,
        function () internal view returns (bytes32) id
    ) internal {
        uint256 ts = deploymentTimestamp.deploymentTimestamps(id());
        // If the script has not been deployed yet, or if the block is in the past
        // we will deploy the script and execute the governance
        if (ts == 0 || ts > _originalTimestamp) {
            deploy();
            (address[] memory targets, uint256[] memory values, bytes[] memory payloads,,) = deployGovernance();
            vm.startPrank(Mainnet.TIMELOCK);
            for (uint256 i; i < targets.length; i++) {
                (bool success,) = targets[i].call{value: values[i]}(payloads[i]);
                require(success, "Proposal execution failed");
            }
            vm.stopPrank();
        }
        //
        else if (ts < _originalTimestamp) {
            // We are in the following situation:
            // - The script has been deployed, i.e. contracts have been created
            // - Governance is maybe pending
            // So we will check if proposalId has been executed on Governance
            // If the proposalId has been executed, we can set the address
            // If the proposalId has not been executed, we can set the address and
            // we will execute governance it manually
            // Todo: to speed up the process, we could enter only if we are close from the delay.

            setAddress();

            // Get the proposal parameters
            (
                address[] memory targets,
                uint256[] memory values,
                bytes[] memory payloads,
                bytes32 predecessor,
                bytes32 salt
            ) = deployGovernance();
            // Get the proposalId
            bytes32 proposalId = keccak256(abi.encode(targets, values, payloads, predecessor, salt));

            // Check if the proposalId has been executed
            if (!timelock.isOperationDone(proposalId)) {
                // Execute the proposal
                // Instead of timejumping and executing the proposal when timelock is ready
                // we will execute the proposal manually
                // This is a workaround to avoid timejumping and waiting for the timelock
                // Todo: it could be nice to give choice on the timejumping or not.
                // Todo: it could be nice to ensure that the proposalId is pending or ready,
                // otherwise it means that the proposalId might be wrong.
                vm.startPrank(Mainnet.TIMELOCK);
                for (uint256 i; i < targets.length; i++) {
                    (bool success,) = targets[i].call{value: values[i]}(payloads[i]);
                    require(success, "Proposal execution failed");
                }
                vm.stopPrank();
            }
        } else {
            // The script has been deployed and the proposalId has been executed
            // We can set the address, but in theory we should not be here
            setAddress();
        }
    }
}

// Todo:
// - Add console.log or event when addresses are set
