// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Vm, VmSafe} from "forge-std/Vm.sol";

import {Script_001} from "test/deploy/1-deploy-ousd.sol";

contract Deploy_001 is Script, Script_001 {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.envString("MAINNET_SEPOLIA_RPC_URL"));

        vm.isContext(VmSafe.ForgeContext.ScriptBroadcast)
            ? vm.startBroadcast(vm.envUint("MAINNET_DEPLOYER_PRIVATE_KEY"))
            : vm.startBroadcast(vm.envAddress("MAINNET_DEPLOYER"));

        _create_001();
        vm.stopBroadcast();
    }
}

// How to run:
// forge script script/deploy/1-deploy-ousd.sol --broadcast --verify -vvvv
//
