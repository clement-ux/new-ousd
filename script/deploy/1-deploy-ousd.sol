// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "dependencies/forge-std-1.9.6/src/Script.sol";

import {OUSDScript} from "test/deploy/1-deploy-ousd.sol";

contract Deploy_001 is Script, OUSDScript {
    function run() public {
        IS_TEST = false;
        vm.startBroadcast();
        deploy_1(DeployActions.Create);
        vm.stopBroadcast();
    }
}
