import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';

Future<void> main() async {
  await metamask();
}

Future<void> metamask() async {
  final eth = window.ethereum;
  if (eth == null) {
    print('MetaMask is not available');
    return;
  }

  final client = Web3Client.custom(eth.asRpcService());
  final credentials = await eth.requestAccount();

  print('Using ${credentials.address}');
  print('Client is listening: ${await client.isListeningForNetwork()}');

  final message = Uint8List.fromList(utf8.encode('Hello from web3dart'));
  final signature = await credentials.signPersonalMessage(message);
  print('Signature: ${base64.encode(signature)}');
}

Future<void> binanceChainWallet() async {
  final bsc = window.BinanceChain;
  if (bsc == null) {
    print('BinanceWallet is not available');
    return;
  }

  final client = Web3Client.custom(bsc.asRpcService());
  final credentials = await bsc.requestAccount();

  print('Using ${credentials.address}');
  print('Client is listening: ${await client.isListeningForNetwork()}');

  final message = Uint8List.fromList(utf8.encode('Hello from web3dart'));
  final signature = await credentials.signPersonalMessage(message);
  print('Signature: ${base64.encode(signature)}');
}

Future<void> okxWallet() async {
  final okx = window.OkxChainWallet;
  if (okx == null) {
    print('OkxChainWallet is not available');
    return;
  }

  final client = Web3Client.custom(okx.asRpcService());
  final credentials = await okx.requestAccount();

  print('Using ${credentials.address}');
  print('Client is listening: ${await client.isListeningForNetwork()}');

  final message = Uint8List.fromList(utf8.encode('Hello from web3dart'));
  final signature = await credentials.signPersonalMessage(message);
  print('Signature: ${base64.encode(signature)}');
}
