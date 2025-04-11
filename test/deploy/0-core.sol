// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script_001} from "./1-deploy-ousd.sol";
import {Script_002} from "./2-deploy-oeth.sol";
import {Script_003} from "./3-deploy-ousd-vault.sol";

contract Deploys is Script_001, Script_002, Script_003 {}
