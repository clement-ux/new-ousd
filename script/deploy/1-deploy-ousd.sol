// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "dependencies/forge-std-1.9.6/src/Script.sol";
import {Vm, VmSafe} from "dependencies/forge-std-1.9.6/src/Vm.sol";

import {OUSDScript} from "test/deploy/1-deploy-ousd.sol";

contract Deploy_001 is Script, OUSDScript {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.envString("MAINNET_SEPOLIA_RPC_URL"));

        vm.isContext(VmSafe.ForgeContext.ScriptBroadcast)
            ? vm.startBroadcast(vm.envUint("MAINNET_DEPLOYER_PRIVATE_KEY"))
            : vm.startBroadcast(vm.envAddress("MAINNET_DEPLOYER"));

        _create_1();
        vm.stopBroadcast();
    }
}

// How to run:
// forge script script/deploy/1-deploy-ousd.sol --broadcast --verify -vvvv
//
