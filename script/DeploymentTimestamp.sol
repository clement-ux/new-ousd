// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DeploymentTimestamp {
    mapping(bytes32 deploymentId => uint256 timestamp) public deploymentTimestamps;

    constructor() {
        deploymentTimestamps[getDeploymentId("Script_001", 1)] = 0; //1711987652; //1743521277;
    }

    function getDeploymentTimestamp(bytes32 deploymentId) public view returns (uint256) {
        return deploymentTimestamps[deploymentId];
    }

    function getDeploymentId(string memory fileName, uint256 chainId, bytes32 salt) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(fileName, chainId, salt));
    }

    function getDeploymentId(string memory fileName, uint256 chainId) public pure returns (bytes32) {
        return getDeploymentId(fileName, chainId, 0);
    }
}
