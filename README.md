<!-- @format -->

# English README 　[Jump to Japanese Version](#japanese)

# Note: This is a work in progress

- As Ethers.js V5 is deprecated for the use of Sepolia testnet on the front-end, I am currently updating the code to Ethers.js V6.
- Stackup.sh framework (UserOp) is not compliant with Ethers.js V6 new types and methods, so i am re-addaptating this as well.
- I have a Goerli version aswell using ethers.js V5. But when I tested it, due to an upgrade of entry points to v0.7, Stackup.sh isn't usable until they update their framework. Due to this all transactions are reverted.

## Getting Started

### Clone the repository

```bash
git clone https://github.com/Jer-B/Foundry_multisig_wallet/
```

- Change directory

```bash
cd Foundry_multisig_wallet/contracts
```

### Foundry Initialization

```
forge init
```

- Install dependencies

```bash
forge install OpenZeppelin/openzeppelin-contracts@v4.9.3 --no-commit && forge install eth-infinitism/account-abstraction --no-commit
```

#### Contracts deployment

- Replace RPC, Private Key and Etherscan API key by yours.

```
forge script script/WalletFactory.s.sol --rpc-url [YOUR RPC API KEY] --private-key [YOUR PRIVATE KEY] --broadcast --etherscan-api-key [YOUR ETHERSCAN API KEY] -vvv
```

- Replace the contract by your deployed WalletFactory contract address in:

```
 src/utils/constants.ts
```

### Environment variables

- Creates necessary accounts and projects to get the keys you need for the .env file :

For wallet connect, get a WalletConnect Cloud account, then create a project and get your key. Nothing more is required [Wallet Connect Doc](https://docs.walletconnect.com/advanced/migration-from-v1.x/dapps#1-get-a-walletconnect-cloud-project-id)

- For supabase, create an account and a project. Then get your database URL. [Supabase Doc](https://supabase.io/docs/guides/with-nextjs)

- For Stackup.sh, create an account and a project. Then get your API key. [Stackup.sh Doc](https://docs.stackup.sh/docs/node-api)

- Create an .env file in the root directory of the project. And put the below in it, replace the values by yours:

```
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=" YOUR WALLET CONNECT KEY "
DATABASE_URL=" YOUR SUPABASE DATABASE URL "
NEXT_PUBLIC_STACKUP_API_KEY=" YOUR STACKUP API KEY "
```

### Next.js Initialization

- Change directory

```bash
cd Foundry_multisig_wallet/
```

#### Install dependencies

```bash
npm install
```

#### Run the development server:

- Run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.
<br />
<br />

<a name="japanese"></a>

# 日本語版の README

# 注意: これは作業中です

- Ethers.js V5 は Sepolia テストネットのフロントエンド使用が非推奨になったため、現在 Ethers.js V6 へのコード更新を行っています。
- Stackup.sh フレームワーク（UserOp）は Ethers.js V6 の新しいタイプやメソッドに対応していないため、これも再適応しています。
- Ethers.js V5 を使用した Goerli バージョンもありますが、v0.7 へのエントリーポイントのアップグレードのため、Stackup.sh は彼らのフレームワークを更新するまで使用できません。そのため、全てのトランザクションはリバートされました。

## はじめに

### リポジトリのクローン

```bash
git clone https://github.com/Jer-B/Foundry_multisig_wallet/
```

- ディレクトリを変更

```bash
cd Foundry_multisig_wallet/contracts
```

### Foundry の初期化

```
forge init
```

- 依存関係のインストール

```bash
forge install OpenZeppelin/openzeppelin-contracts@v4.9.3 --no-commit && forge install eth-infinitism/account-abstraction --no-commit
```

#### コントラクトのデプロイメント

- RPC、プライベートキー、Etherscan の API キーをあなたのものに置き換えてください。

```
forge script script/WalletFactory.s.sol --rpc-url [YOUR RPC API KEY] --private-key [YOUR PRIVATE KEY] --broadcast --etherscan-api-key [YOUR ETHERSCAN API KEY] -vvv
```

- 以下にデプロイされた WalletFactory コントラクトアドレスを置き換えてください:

```
 src/utils/constants.ts
```

### 環境変数

- .env ファイルに必要なキーを取得するために必要なアカウントとプロジェクトを作成します:

- WalletConnect Cloud アカウントを取得し、プロジェクトを作成してキーを取得します。それ以上のことは必要ありません。[Wallet Connect Doc](https://docs.walletconnect.com/advanced/migration-from-v1.x/dapps#1-get-a-walletconnect-cloud-project-id)

- Supabase の場合、アカウントを作成し、プロジェクトを立ち上げてデータベース URL を取得します。[Supabase Doc](https://supabase.io/docs/guides/with-nextjs)

- Stackup.sh の場合、アカウントを作成し、プロジェクトを立ち上げて API キーを取得します。[Stackup.sh Doc](https://docs.stackup.sh/docs/node-api)

- プロジェクトのルートディレクトリに.env ファイルを作成し、以下のように記入し、あなたの値で置き換えてください:

```
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=" YOUR WALLET CONNECT KEY "
DATABASE_URL=" YOUR SUPABASE DATABASE URL "
NEXT_PUBLIC_STACKUP_API_KEY=" YOUR STACKUP API KEY "
```

### Next.js の初期化

- ディレクトリを変更

```bash
cd Foundry_multisig_wallet/
```

#### 依存関係をインストールする

```bash
npm install
```

#### 開発サーバーの実行

- 開発サーバーを実行します:

```bash
npm run dev
```

ブラウザで[http://localhost:3000](http://localhost:3000)を開いて結果を確認します。
