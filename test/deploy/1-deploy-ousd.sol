// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OUSD} from "../../src/token/OUSD.sol";
import {InitializeGovernedUpgradeabilityProxy} from "../../src/proxies/InitializeGovernedUpgradeabilityProxy.sol";
import {Base} from "test/Base.sol";
import {Mainnet} from "test/Addresses.sol";
import {Mainnet} from "test/Addresses.sol";

contract OUSDScript is Base {
    bytes32 public constant SALT_DEPLOY_1 = 0;

    function deploy_1() internal {
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

    function deploy_1_governance()
        internal
        view
        returns (address[] memory, uint256[] memory, bytes[] memory, bytes32, bytes32)
    {
        uint8 actionCount = 1;
        address[] memory targets = new address[](actionCount);
        uint256[] memory values = new uint256[](actionCount);
        bytes[] memory payloads = new bytes[](actionCount);
        bytes32 predecessor;
        bytes32 salt;

        targets[0] = address(ousd);
        payloads[0] = abi.encodeWithSelector(OUSD.delegateYield.selector, address(0x123), address(0x456));

        return (targets, values, payloads, predecessor, salt);
    }

    function deploy_1_id() internal view returns (bytes32) {
        return keccak256(abi.encodePacked("OUSDScript", block.chainid, SALT_DEPLOY_1));
    }

    function deploy_1_setAddresses() public {
        ousd = OUSD(Mainnet.OUSD);
    }
}
