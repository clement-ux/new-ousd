// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSD} from "../../src/token/OUSD.sol";
import {InitializeGovernedUpgradeabilityProxy} from "../../src/proxies/InitializeGovernedUpgradeabilityProxy.sol";
import {Mainnet} from "test/Addresses.sol";
import {DeployTemplate} from "test/deploy/999-deploy.sol";

contract OUSDScript is DeployTemplate {
    bytes32 public constant SALT_DEPLOY_1 = 0;

    function deploy_1(DeployActions action) public returns (GovernancePayload memory gp) {
        if (action == DeployActions.Create) {
            _create_1();
        } else if (action == DeployActions.SetAddresses) {
            _setAddresses_1();
        } else if (action == DeployActions.Governance) {
            gp = _governance_1();
        } else if (action == DeployActions.Id) {
            gp = _scriptKey_1();
        }
    }

    function _create_1() internal {
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

    function _governance_1() internal view returns (GovernancePayload memory) {
        uint8 actionCount = 1;
        address[] memory targets = new address[](actionCount);
        uint256[] memory values = new uint256[](actionCount);
        bytes[] memory payloads = new bytes[](actionCount);
        bytes32 predecessor;
        bytes32 salt;

        targets[0] = address(ousd);
        payloads[0] = abi.encodeWithSelector(OUSD.delegateYield.selector, address(0x123), address(0x456));

        return (
            GovernancePayload({
                targets: targets,
                values: values,
                payloads: payloads,
                predecessor: predecessor,
                salt: salt,
                scriptKey: _scriptKey_1().scriptKey
            })
        );
    }

    function _scriptKey_1() internal view returns (GovernancePayload memory gp) {
        gp.scriptKey = keccak256(abi.encodePacked("OUSDScript", block.chainid, SALT_DEPLOY_1));
    }

    function _setAddresses_1() internal {
        ousd = OUSD(Mainnet.OUSD);
        emit AddressSet(address(ousd));
    }
}
