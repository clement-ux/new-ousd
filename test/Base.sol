// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSD} from "src/token/OUSD.sol";
import {OETH} from "src/token/OETH.sol";
import {InitializeGovernedUpgradeabilityProxy} from "src/proxies/InitializeGovernedUpgradeabilityProxy.sol";
import {TimelockController} from "@openzeppelin-4.6.0/contracts/governance/TimelockController.sol";

import {DeploymentTimestamp} from "script/DeploymentTimestamp.sol";

import {Test} from "forge-std/Test.sol";

contract Base is Test {
    OUSD ousd;
    OETH oeth;

    TimelockController timelock;
    InitializeGovernedUpgradeabilityProxy ousdProxy;
    InitializeGovernedUpgradeabilityProxy oethProxy;

    DeploymentTimestamp deploymentTimestamp;
}
