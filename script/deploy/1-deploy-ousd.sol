// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Vm, VmSafe} from "forge-std/Vm.sol";
import {Mainnet} from "test/Addresses.sol";
import {console} from "forge-std/console.sol";

import {Script_001} from "test/deploy/1-deploy-ousd.sol";

contract Deploy_001 is Script, Script_001 {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.envString("MAINNET_SEPOLIA_RPC_URL"));

        vm.isContext(VmSafe.ForgeContext.ScriptBroadcast)
            ? vm.startBroadcast(vm.envUint("MAINNET_DEPLOYER_PRIVATE_KEY"))
            : vm.startBroadcast(vm.envAddress("MAINNET_DEPLOYER"));

        deploy_contract();
        vm.stopBroadcast();

        if (vm.isContext(VmSafe.ForgeContext.ScriptDryRun)) require(testGovernance(), "Governance test failed");

        // Log the deployment actions
        // Generate json
    }

    function deploy_contract() internal {
        // Deploy the contract
        _create_001();
    }

    function testGovernance() public returns (bool) {
        GovernancePayload memory gp = _governance_001();

        vm.startPrank(Mainnet.TIMELOCK);
        for (uint256 i; i < gp.targets.length; i++) {
            (bool success,) = gp.targets[i].call{value: gp.values[i]}(gp.payloads[i]);
            require(success, "Proposal execution failed");
        }
        vm.stopPrank();

        return true;
    }
}

// How to run:
// forge script script/deploy/1-deploy-ousd.sol --broadcast --verify -vvvv
//
