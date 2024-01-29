// SPDX-License-Identifier:MIT

// Use to create new wallets and deployments of them
// use UUPS proxy
// deploy new instances of proxy instead of new wallets.sol (wallets.sol is the logic contract)

pragma solidity ^0.8.18;

import {IEntryPoint} from "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {Wallet} from "./Wallet.sol";
import {ERC1967Proxy} from "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Create2} from "../lib/openzeppelin-contracts/contracts/utils/Create2.sol";

contract WalletFactory {
    Wallet public immutable walletImplementation;

    constructor(IEntryPoint _EntryPoint) {
        walletImplementation = new Wallet(_EntryPoint, address(this));
    }

    function createNewWallet(
        address[] memory owners,
        uint256 salt
    ) external returns (Wallet) {
        // get the address of the wallet
        address walletAddress = getWalletAddress(owners, salt);

        uint256 counterFactAddrSize = walletAddress.code.length;

        // if not empty return the wallet at the counterFactAddr
        if (counterFactAddrSize > 0) {
            return Wallet(payable(walletAddress));
        }

        //if empty, deploy and return a new created Wallet
        bytes memory walletInitiation = abi.encodeCall(
            Wallet.initializeWithOwners,
            owners
        );
        ERC1967Proxy proxy = new ERC1967Proxy{salt: bytes32(salt)}(
            address(walletImplementation),
            walletInitiation
        );
        return Wallet(payable(address(proxy)));
    }

    // get the address of the wallet contract using the salt and the owners addresses
    function getWalletAddress(
        address[] memory owners,
        uint256 salt
    ) public view returns (address) {
        // Encode the initialize function in Wallet with owners addresses array into a bytes array
        bytes memory walletInitiation = abi.encodeWithSignature(
            "initializeWithOwners(address[])",
            owners
        );

        // Encode the proxy contract constructor which includes the addresses of the wallet implementation and the wallet initiation
        bytes memory proxyConstruct = abi.encode(
            address(walletImplementation),
            walletInitiation
        );

        // Encode the creationCode for ERC1967Proxy with the proxyConstruct data
        bytes memory bytecode = abi.encodePacked(
            type(ERC1967Proxy).creationCode,
            proxyConstruct
        );

        // Hash the bytecode
        bytes32 bytecodeHash = keccak256(bytecode);

        return Create2.computeAddress(bytes32(salt), bytecodeHash);
        // return
        //     Create2.computeAddress(
        //         keccak256(abi.encodePacked(owners)),
        //         salt,
        //         address(this)
        //     );
    }

    // function to create new wallets by redeploying a new wallet instance
}
