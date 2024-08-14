## 2.7.4
-  Improved error parsing, support of non-json errors

## 2.7.3
-  added chainChanged, accountsChanged, connect, disconnect, message metamask event streams

## 2.7.2
-  requestAccounts instead of requestAccount for Metamask

## 2.7.1
- Fixed multiplatform compatibility

## 2.7.0
- Now passing error code, message and data in all exceptions
- Fixed multiplatform compatibility
- Added dodao.dev chain to metamask example

## 2.6.4
- Fixed web metamask example

## 2.6.3
- Fixed web metamask example

## 2.6.2
- Fix imports

## 2.6.1
- Fix stub includes

## 2.6.0
- Add Binance Wallet and Okx Wallet support (from MacaronSwap repo)
- Added addChain and switchChain functions to example
- switched to stream_channel: ^2.1.1 to support stable flutter channel

## 2.5.11
- Add helper for handling amounts with decimals in `EtherAmount` class

## 2.5.10
- Report of Web3Dart's last commits
- DeployedContract function method supports more than one function with different parameters

## 2.5.9
- Handle rawRequest errors
- Report of Web3Dart's PRs
    PR 115 : Report Fix for errors in generated dart bindings
    PR 114: Feature Addition: EthrDID Constructors
    PR 108: Implemented calculation of max fee per gas
    PR 106: add nullable topics in filters
    PR 86: Eip1559
    PR 79: Report Replace depreciated field access in ReadMe snippets
    PR 73: Report JSON-RPC: fix type-error to get useful RPCErrors
    PR 19: Update readme to remove deprecated method
## 2.5.8
- update dependencies
## 2.5.7
- getGasInEIP1559 to support hardhat, added lastBaseFeePerGas
## 2.5.6+1
- fixed merge issue
## 2.5.6
- fixed generated contract abi encoder to support dynamic maps in input data, adding support for contracts which have structs as inputs https://docs.soliditylang.org/en/develop/abi-spec.html#formal-specification-of-the-encoding
## 2.5.5+5
- fix fetching mempool transactions that do not yet have a blockhash
## 2.5.5+4
- removed getBlockByNumberWithTransactions because getBlockInformation already gets all data
## 2.5.5+3
- switch to declareFinal instead of deprecated assignFinal in generator.dart
## 2.5.5+2
- fixed linter issues and updated CHANGELOG
## 2.5.5+1
- fixed linter issues
## 2.5.5
- added hardhat as dev dependency to build export IERC20.abi.json to generate IERC20.g.dart for generator tests
- fixed integration test and returned token info test
## 2.5.4
- added js_util_stub.dart to support javascript object conversion for metamask, fixed getFeeHistory, fixed getBlockInformation, changed from solc to solcjs
## 2.5.3
- fixed getGasInEIP1559
- fixed sender type in solidity contract dart bindings generator
## 2.5.2
- return build.yaml for contract generator
## 2.5.1
- update pubspec
## 2.5.0 first WebThree version
- Renaming library to WebThree in order to maintain a community developed fork.
- Bumping version number to 2.5.0, pull requests are greatly appreciated. No breaking changes were made.
- the reason for creating this fork from https://github.com/simulous/web3dart 2.3.5 was that web3dart 2.4.1 currently published at https://pub.dev/packages/web3dart/ Github repo https://github.com/xclud/web3dart has factored out contract generator and metamask integration, making a breaking change.
The following changes were implemented:
  - added stubs for dart_wrappers.dart and dart:js, added conditional dependencies import to metamask example in order to support web and other platform builds from a single codebase
  - fix signPersonalMessage to use modern personal_sign instead of eth_sign
  - fix type issues in getTransactionHistory
  - Merged all reasonamble commits from the forks network, thank you @@simolus3 @superkeka @alexeyinkin @xclud @TheGreatAxios @rgplvr @thegamenicorus @MahmoudKhalid @superkeka
  from @superkeka/web3dart
  - Make EthereumAddress Comparable
  - StateMutability error when parsing json abi that contains an event simolus3/web3dart#13
  - Make getTransactionByHash nullable
  - Expose number utility functions simolus3/web3dart#3
  - decodeCall Uses the known types of the function parameters to parse them from the binary call data. The reverse of [encodeCall].
  - make rpc call public
  - Add block number to BlockInformation, add BlockInformationWithTransactions, add getBlockByNumberWithTransactions
  - API Documentation on how to create the wallet files, HD wallets simolus3/web3dart#2
  - Fix fetching mempool transactions that do not yet have blockHash
  - Erc20 class support for name, symbol and decimals functions.
from @GangemiLorenzo/web3dart
  - add sender to generated contract read
  - add argSender to generated contracts
from @kryptogo/web3dart
  - add toMap for tx receipt
  - add value for eth_call
from @thegamenicorus/web3dart
  - fix filter not found
  - add getTransactionHistory
  - keep rpc running
  - add getPendingTransactions
from @thelazyindian/web3dart
  - Accept Null message
 Fix EIP1559Information
from @MahmoudKhalid/web3dart
  - Fix EIP1559Information
  - Added getGasInEIP1559 method
  - Added feeHistory method
from @rgplvr/web3dart
  fix fetchChainIdFromNetworkId
from @naiba/web3dart
  - fix uint8list overflow

## @simulous/web3dart changelog:

## 2.3.5

- Ensuring quality and performance.

## 2.3.4

- Adds `name`, `symbol` and `decimals` functions to ERC20.

## 2.3.3

- Fix signing legacy transactions without gas and without a client.

## 2.3.2

- Support EIP-1559 transactions.

## 2.3.1

- Fix the `Web3Client.custom` constructor not setting all required fields.

## 2.3.0

- Support overloaded methods for generated contracts

## 2.2.0

- Add `EthPrivateKey.publicKey` getters
- Fix `window.ethereum` always being non-null, even if no provider is available

## 2.1.4

- Fix a generator crash for unexpected `devdoc` values

## 2.1.3

- Fix `EthPrivateKey.createRandom` sometimes failing

## 2.1.2

- Fix contract generation for events
- Don't generate a method for the fallback method
- Fix parsing contract abis in the presence of unknown function types

## 2.1.1

- Respect the `value` parameter in `estimateGas`

## 2.1.0

- Add `package:web3dart/browser.dart`, a library for using this package in
  Ethereum-enabled browsers.
- Add code generator for smart contracts. To use it, just put the generated abi
  json into a `.abi.json` file, add a dev-dependency on `build_runner` and run
  `(flutter | dart) pub run build_runner build`.
- Add the `package:web3dart/contracts/erc20.dart` library for interacting with an
  [ERC-20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md) smart contract.

## 2.0.0

- __Breaking__: Renamed `TransactionReceipt.fromJson` to `TransactionReceipt.fromMap`
- __Breaking__: Removed the `backgroundIsolate` option from `Web3Client`.
  For background isolates, instead use `runner: await IsolateRunner.spawn()` from `package:isolate`.
- __Breaking__: Changed `TransactionInformation.r` and `TransactionInformation.s` from `Uint8List` to
  `BigInt`
- __Breaking__: When not setting the `maxGas` argument, this library will now estimate it instead of using
  a fixed upper bound.
- Migrate to null safety
- Add `ecRecover` and `isValidSignature` to verify messages. Thanks, [brickpop](https://github.com/brickpop)!
- Add `compressPublicKey` and `decompressPublicKey` to obtain a compressed or expanded version of keys.
- Add `getLogs` method to `Web3Client`. Thanks, [jmank88](https://github.com/jmank88)!
- Add `sendRawTransaction` to send a raw, signed transaction.
- Fix `hexToDartInt` not actually parsing hex ([#81](https://github.com/simolus3/web3dart/issues/81))
- Support for background isolates is temporarily disabled until `package:isolate` migrates to null safety

## 1.2.3

- include a `0x` for hex data in `eth_estimateGas` - thanks, [@Botary](https://github.com/Botary)

## 1.2.2

- Fixed a bug when decoding negative integers ([#73](https://github.com/simolus3/web3dart/issues/73))

## 1.2.0

- Added `estimateGas` method on `Web3Client` to estimate the amount of gas that
  would be used by a transaction. In 1.2.1, the `atBlock` parameter on `estimateGas` was deprecated and will be ignored.

## 1.1.1, 1.1.1+1

- Fix parsing transaction receipts when the block number is not yet available.
Thanks to [@chart21](https://github.com/chart21) for the fix.
- Fix a typo that made it impossible to load the coinbase address. Thanks to
[@modulovalue](https://github.com/modulovalue) for the fix.

## 1.1.0

- Added `getTransactionReceipt` to get more detailed information about a
transaction, including whether it was executed successfully or not.

## 1.0.0

Basically a complete rewrite of the library - countless bug fixes, a more fluent
and consistent api and more features:

- experimental api to perform expensive operations in a background isolate. Set
`enableBackgroundIsolate` to true when creating a `Web3Client` to try it out.
- Events! Use `addedBlocks`, `pendingTransactions` and `events` for auto-updating
streams.
- The client now has a `dispose()` method which should be called to stop the
background isolate and terminate all running streams.

This version contains breaking changes! Here is an overview listing some of them.

| Before                                                                                                 |                                                                                                       Updated API |
| :----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------: |
| Creating credentials via `Credentials.fromPrivateKeyHex`                                               |                                 Use the `EthPrivateKey` class or, even better, `client.credentialsFromPrivateKey` |
| Sending transactions or calling contract functions                                                     | The api has been changed to just a single methods instead of a transaction builder. See the examples for details. |
| Low-level cryptographic operations like signing, hashing and converting hex - byte array - integer |                                  Not available in the core library. Import `package:web3dart/crypto.dart` instead |

If you run into problems after updating, please [create an issue](https://github.com/simolus3/web3dart/issues/new).

## 0.4.4

- Added `getTransactionByHash` method - thank you, [maxholman](https://github.com/maxholman)!
- Allow a different N parameter for scrypt when creating new wallets.

## 0.4.0

- New APIs allowing for a simpler access to wallets, credentials and addresses
- More examples in the README

## 0.2.1

- More solidity types, not with encoding.

## 0.2

- Send transactions and call messages from smart contracts on the
  Blockchain.

## 0.1

- Create new Ethereum accounts

## 0.0.2

- Send and sign transactions

## 0.0.1

- Initial version, created by Stagehand
