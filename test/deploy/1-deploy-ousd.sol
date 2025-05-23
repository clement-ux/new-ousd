// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSD} from "../../src/token/OUSD.sol";
import {InitializeGovernedUpgradeabilityProxy} from "../../src/proxies/InitializeGovernedUpgradeabilityProxy.sol";
import {Mainnet} from "test/Addresses.sol";
import {DeployTemplate} from "test/deploy/DeployTemplate.sol";

contract Script_001 is DeployTemplate {
    bytes32 public constant SALT_DEPLOY_1 = 0;

    function deploy_1(DeployActions action) public returns (GovernancePayload memory gp) {
        if (action == DeployActions.Create) {
            _create_001();
        } else if (action == DeployActions.SetAddresses) {
            _setAddresses_001();
        } else if (action == DeployActions.Governance) {
            gp = _governance_001();
        } else if (action == DeployActions.Id) {
            gp = _scriptKey_001();
        }
    }

    function _create_001() internal {
        //Deploy Proxy
        ousdProxy = new InitializeGovernedUpgradeabilityProxy();
        vm.label(address(ousdProxy), "OUSD Proxy");

        // Deploy implementation
        ousd = new OUSD();
        vm.label(address(ousd), "OUSD Implementation");

        // Initialize the proxy with the implementation address
        bytes memory initData = abi.encodeWithSelector(OUSD.initialize.selector, address(Mainnet.OUSD_VAULT), 1e27, "");
        ousdProxy.initialize({_logic: address(ousd), _initGovernor: Mainnet.TIMELOCK, _data: initData});

        ousd = OUSD(address(ousdProxy));
    }

    function _governance_001() internal view returns (GovernancePayload memory) {
        uint8 actionCount = 1;
        address[] memory targets = new address[](actionCount);
        uint256[] memory values = new uint256[](actionCount);
        string[] memory signatures = new string[](actionCount);
        bytes[] memory payloads = new bytes[](actionCount);
        bytes32 predecessor;
        bytes32 salt;

        targets[0] = address(ousd);
        values[0] = 0;
        signatures[0] = "delegateYield(address,address)";
        // We use signature over selector, because we need signature when proposing on the governance.
        payloads[0] = abi.encodeWithSignature(signatures[0], address(0x123), address(0x456));

        return (
            GovernancePayload({
                targets: targets,
                values: values,
                signatures: signatures,
                payloads: payloads,
                predecessor: predecessor,
                salt: salt,
                scriptKey: _scriptKey_001().scriptKey
            })
        );
    }

    function _scriptKey_001() internal view returns (GovernancePayload memory gp) {
        gp.scriptKey = keccak256(abi.encodePacked("Script_001", block.chainid, SALT_DEPLOY_1));
    }

    function _setAddresses_001() internal {
        ousd = OUSD(Mainnet.OUSD);
        emit AddressSet(address(ousd));
    }
}
