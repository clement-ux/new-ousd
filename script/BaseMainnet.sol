// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Base} from "script/Base.sol";

abstract contract BaseMainnet is Base {
    constructor() Base("MAINNET_SEPOLIA") {}
}
