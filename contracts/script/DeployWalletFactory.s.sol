// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Script.sol";
import {WalletFactory} from "../src/WalletFactory.sol";
import {IEntryPoint} from "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract DeployWalletFactory is Script {
    // Address of the EntryPoint contract on Sepolia
    IEntryPoint constant ENTRYPOINT =
        IEntryPoint(0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789);

    function run() external {
        vm.startBroadcast();

        // Initialize the WalletFactory contract
        WalletFactory walletFactory = new WalletFactory(ENTRYPOINT);

        vm.stopBroadcast();
    }
}
