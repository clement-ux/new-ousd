// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Vm, VmSafe} from "forge-std/Vm.sol";

abstract contract Base is Script {
    string public DEPLOY_CHAIN;
    string public DEPLOY_RPC;
    string public DEPLOY_PK;
    string public DEPLOY_DEPLOYER;

    constructor(string memory chain) {
        require(bytes(chain).length > 0, "DEPLOY_CHAIN not set");
        DEPLOY_RPC = string(abi.encodePacked(chain, "_RPC_URL"));
        require(vm.envExists(DEPLOY_RPC), string(abi.encodePacked(DEPLOY_RPC, " not set in .env")));
        DEPLOY_PK = string(abi.encodePacked(chain, "_DEPLOYER_PRIVATE_KEY"));
        DEPLOY_DEPLOYER = string(abi.encodePacked(chain, "_DEPLOYER"));
        require(
            vm.envExists(DEPLOY_PK) || vm.envExists(DEPLOY_DEPLOYER),
            string(abi.encodePacked(DEPLOY_PK, " or ", DEPLOY_DEPLOYER, " not set in .env"))
        );
    }

    modifier deployEnv() {
        vm.createSelectFork(vm.envString(DEPLOY_RPC));

        vm.isContext(VmSafe.ForgeContext.ScriptBroadcast)
            ? vm.startBroadcast(vm.envUint(DEPLOY_PK))
            : vm.startBroadcast(vm.envAddress(DEPLOY_DEPLOYER));

        _;

        vm.stopBroadcast();
    }

    modifier hooks() {
        hookBeforeRun();
        _;

        hookAfterRun();
    }

    function run() public hooks {
        // /!\ ---------------------/!\----------------------/!\
        // This is where the deployment of the contract happens !
        // /!\ ---------------------/!\----------------------/!\
        deploy_contract();
    }

    function deploy_contract() internal virtual deployEnv {}

    function hookBeforeRun() internal virtual {}

    function hookAfterRun() internal virtual {}

    function logGovernanceScript() internal virtual {}

    function createGovernanceJSON() internal virtual {}
}
