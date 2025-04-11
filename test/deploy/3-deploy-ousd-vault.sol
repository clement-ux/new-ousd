// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSD} from "../../src/token/OUSD.sol";
import {VaultCore} from "src/vault/VaultCore.sol";
import {VaultAdmin} from "src/vault/VaultAdmin.sol";
import {VaultInitializer} from "src/vault/VaultInitializer.sol";
import {InitializeGovernedUpgradeabilityProxy} from "../../src/proxies/InitializeGovernedUpgradeabilityProxy.sol";
import {Mainnet} from "test/Addresses.sol";
import {DeployTemplate} from "test/deploy/DeployTemplate.sol";

contract Script_003 is DeployTemplate {
    bytes32 public constant SALT_DEPLOY_3 = 0;

    function deploy_3(DeployActions action) public returns (GovernancePayload memory gp) {
        if (action == DeployActions.Create) {
            _create_3();
        } else if (action == DeployActions.SetAddresses) {
            _setAddresses_003();
        } else if (action == DeployActions.Governance) {
            gp = _governance_003();
        } else if (action == DeployActions.Id) {
            gp = _scriptKey_003();
        }
    }

    function _create_3() internal {
        //Deploy Proxy
        ousdVaultProxy = new InitializeGovernedUpgradeabilityProxy();
        vm.label(address(ousdVaultProxy), "OUSD Vault Proxy");

        // Deploy implementations
        ousdVault = new VaultCore();
        vm.label(address(ousdVault), "OUSD Vault Core Implementation");

        ousdVaultAdmin = new VaultAdmin();
        vm.label(address(ousdVaultAdmin), "OUSD Vault Admin Implementation");

        // Initialize the proxy with the implementation address
        bytes memory initData =
            abi.encodeWithSelector(VaultInitializer.initialize.selector, address(0x1234), address(ousd));
        ousdVaultProxy.initialize({_logic: address(ousdVault), _initGovernor: deployer, _data: initData});

        // Set Admin implementation address
        VaultCore(address(ousdVaultProxy)).setAdminImpl(address(ousdVaultAdmin));

        ousdVault = VaultCore(address(ousdVaultProxy));
    }

    function _governance_003() internal view returns (GovernancePayload memory) {
        uint8 actionCount = 0;
        address[] memory targets = new address[](actionCount);
        uint256[] memory values = new uint256[](actionCount);
        bytes[] memory payloads = new bytes[](actionCount);
        bytes32 predecessor;
        bytes32 salt;

        return (
            GovernancePayload({
                targets: targets,
                values: values,
                payloads: payloads,
                predecessor: predecessor,
                salt: salt,
                scriptKey: _scriptKey_003().scriptKey
            })
        );
    }

    function _scriptKey_003() internal view returns (GovernancePayload memory gp) {
        gp.scriptKey = keccak256(abi.encodePacked("Script_003", block.chainid, SALT_DEPLOY_3));
    }

    function _setAddresses_003() internal {
        ousdVault = VaultCore(Mainnet.OUSD_VAULT);
        emit AddressSet(address(ousd));
    }
}
