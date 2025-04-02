// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DeploymentTimestamp {
    mapping(bytes32 deploymentId => uint256 timestamp) public deploymentTimestamps;

    constructor() {
        deploymentTimestamps[0x0825c85f669276c64493d2b6cf1adc6a2df9634dd20eff9ee97032420a7b9f11] = 0; //1711987652; //1743521277;
    }

    // Todo: a function that take in args:
    // - File name
    // - chain id
    // - salt
    // And returns the computed hash that correspond to the deploy_id
}
