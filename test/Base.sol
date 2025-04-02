// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSD} from "src/OUSD.sol";
import {OETH} from "src/OETH.sol";

import { DeploymentTimestamp } from "script/DeploymentTimestamp.sol";

import {Test} from "lib/forge-std/src/Test.sol";

contract Base is Test {
    OUSD ousd;
    OETH oeth;

    DeploymentTimestamp deploymentTimestamp;
}
