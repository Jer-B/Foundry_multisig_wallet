// import { defaultAbiCoder, keccak256 } from "ethers/lib/utils";
import { AbiCoder, keccak256 } from "ethers";
import { Constants, IUserOperation } from "userop";
import { sepolia } from "wagmi/chains";

export default async function getUserOpHash(userOp: IUserOperation) {
  const abiCoder = new AbiCoder();

  // const encodedUserOp = defaultAbiCoder.encode(
  //   [
  //     "address",
  //     "uint256",
  //     "bytes32",
  //     "bytes32",
  //     "uint256",
  //     "uint256",
  //     "uint256",
  //     "uint256",
  //     "uint256",
  //     "bytes32",
  //   ],
  //   [
  //     userOp.sender,
  //     userOp.nonce,
  //     keccak256(userOp.initCode),
  //     keccak256(userOp.callData),
  //     userOp.callGasLimit,
  //     userOp.verificationGasLimit,
  //     userOp.preVerificationGas,
  //     userOp.maxFeePerGas,
  //     userOp.maxPriorityFeePerGas,
  //     keccak256(userOp.paymasterAndData),
  //   ]
  // );

  const encodedUserOp = abiCoder.encode(
    [
      "address",
      "uint256",
      "bytes32",
      "bytes32",
      "uint256",
      "uint256",
      "uint256",
      "uint256",
      "uint256",
      "bytes32",
    ],
    [
      userOp.sender,
      userOp.nonce,
      userOp.initCode,
      userOp.callData,
      userOp.callGasLimit,
      userOp.verificationGasLimit,
      userOp.preVerificationGas,
      userOp.maxFeePerGas,
      userOp.maxPriorityFeePerGas,
      userOp.paymasterAndData,
    ]
  );

  // const encodedUserOpWithChainIdAndEntryPoint = defaultAbiCoder.encode(
  //   ["bytes32", "address", "uint256"],
  //   [keccak256(encodedUserOp), Constants.ERC4337.EntryPoint, sepolia.id]
  // );
  const encodedUserOpWithChainIdAndEntryPoint = abiCoder.encode(
    ["bytes32", "address", "uint256"],
    [keccak256(encodedUserOp), Constants.ERC4337.EntryPoint, sepolia.id]
  );

  return keccak256(encodedUserOpWithChainIdAndEntryPoint);
}
