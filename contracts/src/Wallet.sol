// SPDX-License-Identifier:MIT

// logic contract
// Used once, then use UUPS proxy.

// extend wallet.sol to inherit from BaseAccount.sol (Basic account implementation)

pragma solidity ^0.8.18;

// BaseAccount.sol -> Basic implementation of a smart contract wallet
// ECDSA.sol -> signature verification
// UserOperation.sol -> struct of the user operation interface

import {IEntryPoint} from "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {TokenCallbackHandler} from "../lib/account-abstraction/contracts/samples/callback/TokenCallbackHandler.sol";
import {BaseAccount} from "../lib/account-abstraction/contracts/core/BaseAccount.sol";
import {ECDSA} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {Initializable} from "../lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import {UserOperation} from "../lib/account-abstraction/contracts/interfaces/UserOperation.sol";
import {UUPSUpgradeable} from "../lib/openzeppelin-contracts/contracts/proxy/utils/UUPSUpgradeable.sol";

contract Wallet is
    BaseAccount,
    Initializable,
    UUPSUpgradeable,
    TokenCallbackHandler
{
    // for Signatures validation
    using ECDSA for bytes32;

    // error message
    // error Wallet__Signature_Verification_Failed();
    error Wallet__No_Owners();
    error Wallet__NotWalletFactory_or_NotEntryPoint_Addresses();
    // error Wallet__ExecuteTransactionError();
    error Wallet__ExecuteTransactionBatch_destination_Error();
    error Wallet__ExecuteTransactionBatch_value_Error();

    //array of owners
    address[] public owners;

    address public immutable walletFactory;

    //Keep track of the entry point state variable
    IEntryPoint public immutable _entryPoint;

    //events
    event WalletInitialized(IEntryPoint indexed entryPoint, address[] owners);

    // modifier to check if the caller is the wallet factory
    modifier _onlyWalletFactoryAndEntryPoint() {
        if (msg.sender == address(_entryPoint) || msg.sender == walletFactory) {
            _;
        } else {
            revert Wallet__NotWalletFactory_or_NotEntryPoint_Addresses();
        }
        _;
    }

    constructor(IEntryPoint _EntryPoint, address _WalletFactory) {
        _entryPoint = _EntryPoint;
        walletFactory = _WalletFactory;
    }

    // function for the entry point to call
    function entryPoint() public view override returns (IEntryPoint) {
        return _entryPoint;
    }

    // function to validate signatures
    //returns 0 or 1, 0 if all signatures are valid, 1 if not
    function _validateSignature(
        UserOperation calldata _userOp,
        bytes32 _hash
    ) internal view override returns (uint256) {
        //convert hash to signed message hash
        bytes32 hash = _hash.toEthSignedMessageHash();

        //decode signatures from userOp and store them in a bytes array
        bytes[] memory signatures = abi.decode(_userOp.signature, (bytes[]));

        //check if the number of signatures is equal to the number of owners
        // require(signatures.length == owners.length, "Invalid number of signatures");

        //loop through owners and verify if signatures correspond to owners addresses
        for (uint256 i = 0; i < owners.length; i++) {
            //recover the address of the signer
            // address signer = hash.recover(signatures[i]);

            //check if the signer is an owner
            if (owners[i] != hash.recover(signatures[i])) {
                // revert Wallet__Signature_Verification_Failed();
                // EntryPoint contract expect the below error message when verification fails
                return SIG_VALIDATION_FAILED;
            }
        }
        // if all signatures are valid, return 0
        return 0;
    }

    // function to initialize the wallet with initial owners
    function initializeWithOwners(
        address[] memory initialOwners
    ) public initializer {
        walletInitializer(initialOwners);
    }

    // function to initialize the wallet, revert if no owners, emit event if success
    function walletInitializer(address[] memory initialOwners) internal {
        if (initialOwners.length > 0) {
            revert Wallet__No_Owners();
        }
        owners = initialOwners;
        emit WalletInitialized(_entryPoint, owners);
    }

    // helper for arbitrary calls
    function _call(
        address _target,
        uint256 _value,
        bytes memory _data
    ) internal {
        (bool success, bytes memory returndata) = _target.call{value: _value}(
            _data
        );
        if (!success) {
            assembly {
                // slice out first 32 bytes of returndata (containing the length of _data)
                // then get the revert message using mload, then revert using the message
                revert(add(returndata, 32), mload(returndata))
            }
        }
        // return (success, returndata);
    }

    // function to execute a transaction, a single call transaction
    // Only the wallet factory or the entrypoint address can call this function
    function executeTransaction(
        address to,
        uint256 value,
        bytes calldata data
    ) external _onlyWalletFactoryAndEntryPoint {
        // call the _call function
        // (bool success, bytes memory returndata) =
        _call(to, value, data);

        // if the call was not successful, revert
        // if (!success) {
        //     revert Wallet__ExecuteTransactionError();
        // }

        // return the return data
        // return returndata;
    }

    //function multiple transaction in one call
    function executeTransactionBatch(
        address[] calldata toUsers,
        uint256[] calldata values,
        bytes[] calldata datas
    ) external _onlyWalletFactoryAndEntryPoint {
        //check if the arrays have the same length
        if (toUsers.length != datas.length) {
            revert Wallet__ExecuteTransactionBatch_destination_Error();
        }
        if (values.length != datas.length) {
            revert Wallet__ExecuteTransactionBatch_value_Error();
        }
        //loop through the arrays and call the _call function
        for (uint256 i = 0; i < toUsers.length; i++) {
            _call(toUsers[i], values[i], datas[i]);
        }
    }

    // allows proxy upgradeability

    function _authorizeUpgrade(
        address newImplementation
    ) internal override _onlyWalletFactoryAndEntryPoint {}

    //helper functions
    // function to encode signatures into bytes array, can be used to pass as data when making calls to the contract
    function encodeSignatures(
        bytes[] memory signatures
    ) public pure returns (bytes memory) {
        return abi.encode(signatures);
    }

    // function to get balance of the contract
    function getBalanceOf() public view returns (uint256) {
        return entryPoint().balanceOf(address(this));
    }

    // function to add deposits to Wallet in entrypoint
    function addDeposits() public payable {
        entryPoint().depositTo{value: msg.value}(address(this));
    }

    //allow the contract to receive ether
    receive() external payable {}
}
