// import { BigNumber } from "ethers";
// import { defaultAbiCoder } from "ethers/lib/utils";
import { BigNumberish } from "ethers";
import { AbiCoder } from "ethers";
import { UserOperationBuilder } from "userop";

// export async function getUserOperationBuilder(
//   walletContract: string,
//   nonce: BigNumber,
//   initCode: Uint8Array,
//   encodedCallData: string,
//   signatures: string[]
// ) {
//   try {
//     const encodedSignatures = defaultAbiCoder.encode(["bytes[]"], [signatures]);
//     const builder = new UserOperationBuilder()
//       .useDefaults({
//         preVerificationGas: 100_000,
//         callGasLimit: 100_000,
//         verificationGasLimit: 2_000_000,
//       })
//       .setSender(walletContract)
//       .setNonce(nonce)
//       .setCallData(encodedCallData)
//       .setSignature(encodedSignatures)
//       .setInitCode(initCode);

//     return builder;
//   } catch (e) {
//     console.error(e);
//     throw e;
//   }
// }

export async function getUserOperationBuilder(
  walletContract: string,
  nonce: BigNumberish,
  initCode: Uint8Array,
  encodedCallData: string,
  signatures: string[]
) {
  try {
    const abiCoder = new AbiCoder();

    // const encodedSignatures = defaultAbiCoder.encode(["bytes[]"], [signatures]);
    const encodedSignatures = abiCoder.encode(["bytes[]"], [signatures]);
    const builder = new UserOperationBuilder()
      .useDefaults({
        preVerificationGas: 100_000,
        callGasLimit: 100_000,
        verificationGasLimit: 2_000_000,
      })
      .setSender(walletContract)
      .setNonce(nonce)
      .setCallData(encodedCallData)
      .setSignature(encodedSignatures)
      .setInitCode(initCode);

    return builder;
  } catch (e) {
    console.error(e);
    throw e;
  }
}
