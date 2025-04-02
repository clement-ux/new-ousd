// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSDScript} from "./1-deploy-ousd.sol";
import {OETHScript} from "./2-deploy-oeth.sol";

contract Deploys is OUSDScript, OETHScript {}
