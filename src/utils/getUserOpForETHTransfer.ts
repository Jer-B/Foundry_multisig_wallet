// import { BigNumber } from "ethers";
import { BigNumberish } from "ethers";
import { concat } from "ethers";
import { Client, Presets } from "userop";
import { BUNDLER_RPC_URL, WALLET_FACTORY_ADDRESS } from "./constants";
import {
  entryPointContract,
  getWalletContract,
  provider,
  walletFactoryContract,
} from "./getContracts";
import { getUserOperationBuilder } from "./getUserOperationBuilder";

// export async function getUserOpForETHTransfer(
//   walletAddress: string,
//   owners: string[],
//   salt: string,
//   toAddress: string,
//   value: BigNumber,
//   isDeployed?: boolean
// ) {
export async function getUserOpForETHTransfer(
  walletAddress: string,
  owners: string[],
  salt: string,
  toAddress: string,
  value: BigNumberish,
  isDeployed?: boolean
) {
  try {
    let initCode = Uint8Array.from([]);
    if (!isDeployed) {
      const data = walletFactoryContract.interface.encodeFunctionData(
        "createNewWallet",
        [owners, salt]
      );

      let str = concat([WALLET_FACTORY_ADDRESS, data]);
      let buffer = Buffer.from(str);
      let bufferUint8Array = Uint8Array.from(buffer);
      // initCode = concat([WALLET_FACTORY_ADDRESS, data]);
      initCode = bufferUint8Array;
    }

    // const nonce: BigNumber = await entryPointContract.getNonce(
    //   walletAddress,
    //   0
    // );
    // const nonce: BigInt = await entryPointContract.getNonce(walletAddress, 0);

    // const walletContract = getWalletContract(walletAddress);
    // const encodedCallData = walletContract.interface.encodeFunctionData(
    //   "executeTransaction",
    //   [toAddress, value, initCode]
    // );

    // const builder = await getUserOperationBuilder(
    //   walletContract.address,
    //   nonce,
    //   initCode,
    //   encodedCallData,
    //   []
    // );
    const nonce: BigNumberish = await entryPointContract.getNonce(
      walletAddress,
      0
    );

    const walletContract = getWalletContract(walletAddress);
    const encodedCallData = walletContract.interface.encodeFunctionData(
      "executeTransaction",
      [toAddress, value, initCode]
    );

    const builder = await getUserOperationBuilder(
      walletAddress,
      nonce,
      initCode,
      encodedCallData,
      []
    );

    // builder.useMiddleware(Presets.Middleware.getGasPrice(provider));

    const client = await Client.init(BUNDLER_RPC_URL);
    await client.buildUserOperation(builder);
    const userOp = builder.getOp();

    return userOp;
  } catch (e) {
    console.error(e);
    if (e instanceof Error) {
      window.alert(e.message);
    }
  }
}
