// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Init} from "../../Init.sol";
import {Mainnet} from "test/Addresses.sol";
import {VaultAdmin} from "src/vault/VaultAdmin.sol";

contract OUSDTest is Init {
    function test_setNumber() public {
        // OUSD tests
        vm.prank(Mainnet.OUSD_VAULT);
        ousd.mint(address(this), 1e27);

        // OUSD vault tests
        address gov = ousdVault.governor();
        vm.prank(gov);
        VaultAdmin(address(ousdVault)).unpauseCapital();

        ousdVault.allocate();
    }
}
