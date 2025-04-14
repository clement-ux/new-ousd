// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

abstract contract Base is Script {
    string public DEPLOY_CHAIN;
    string public DEPLOY_RPC;
    string public DEPLOY_PK;
    string public DEPLOY_DEPLOYER;

    constructor(string memory chain) {
        require(bytes(chain).length > 0, "DEPLOY_CHAIN not set");
        DEPLOY_RPC = string(abi.encodePacked(chain, "_RPC_URL"));
        DEPLOY_PK = string(abi.encodePacked(chain, "_DEPLOYER_PRIVATE_KEY"));
        DEPLOY_DEPLOYER = string(abi.encodePacked(chain, "_DEPLOYER"));
    }
}
