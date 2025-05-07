import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_util' as js_util;
import 'dart:typed_data';

import 'package:web/web.dart' as web;
import 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';

@JS()
@anonymous
class _SwitchChainParams {
  external JSString get chainId;

  external factory _SwitchChainParams({JSString chainId});
}

@JS('JSON.stringify')
external String stringify(JSAny? obj);

Future<void> main() async {
  await metamask();
}

Future<void> metamask() async {
  final eth = web.window.ethereum;
  if (eth == null) {
    print('MetaMask is not available');
    return;
  }
  await switchChain();

  final client = Web3Client.custom(eth.asRpcService());
  final credentials = await eth.requestAccounts();

  print('Using ${credentials[0].address.hex}');
  print('Client is listening: ${await client.isListeningForNetwork()}');

  final message = Uint8List.fromList(utf8.encode('Hello from webthree'));
  final signature = await credentials[0].signPersonalMessage(message);
  print('Signature: ${base64.encode(signature)}');
}

Future<void> binanceChainWallet() async {
  final bsc = web.window.BinanceChain;
  if (bsc == null) {
    print('BinanceWallet is not available');
    return;
  }

  final client = Web3Client.custom(bsc.asRpcService());
  final credentials = await bsc.requestAccounts();

  print('Using ${credentials[0].address.hex}');
  print('Client is listening: ${await client.isListeningForNetwork()}');

  final message = Uint8List.fromList(utf8.encode('Hello from webthree'));
  final signature = await credentials[0].signPersonalMessage(message);
  print('Signature: ${base64.encode(signature)}');
  await switchChain();
}

Future<void> okxWallet() async {
  final okx = web.window.OkxChainWallet;
  if (okx == null) {
    print('OkxChainWallet is not available');
    return;
  }

  final client = Web3Client.custom(okx.asRpcService());
  final credentials = await okx.requestAccounts();

  print('Using ${credentials[0].address.hex}');
  print('Client is listening: ${await client.isListeningForNetwork()}');

  final message = Uint8List.fromList(utf8.encode('Hello from webthree'));
  final signature = await credentials[0].signPersonalMessage(message);
  print('Signature: ${base64.encode(signature)}');
  await switchChain();
}

Future<void> addChain() async {
  final eth = web.window.ethereum;
  if (eth == null) {
    print('Wallet is not available');
    return;
  }
  final params = <String, dynamic>{
    'chainId': '0xd0da0',
    'chainName': 'Dodao',
    'nativeCurrency': <String, dynamic>{
      'name': 'Dodao',
      'symbol': 'DODAO',
      'decimals': 18,
    },
    'rpcUrls': ['https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network'],
    'blockExplorerUrls': [
      'https://tanssi-evmexplorer.netlify.app/?rpcUrl=https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network'
    ],
    'iconUrls': [''],
  };

  try {
    await js_util.promiseToFuture(eth.rawRequest('wallet_addEthereumChain',
        params: js_util.jsify([params]) as JSObject?));
    print('Dodao network added');
  } on Object catch (e) {
    print('Failed to add Dodao network: $e');
  }
}

Future<void> switchChain() async {
  final eth = web.window.ethereum;
  if (eth == null) {
    print('Wallet is not available');
    return;
  }
  try {
    final chainIdResult =
        await js_util.promiseToFuture<String>(eth.rawRequest('eth_chainId'));
    print('Current chain id $chainIdResult');

    await js_util.promiseToFuture(eth.rawRequest('wallet_switchEthereumChain',
        params: js_util.jsify([_SwitchChainParams(chainId: '0xd0da0'.toJS)])
            as JSObject?));
    print('Switched to Dodao network');
  } on EthereumException catch (e) {
    print('EthereumException during switchChain: ${e.code} ${e.message}');
    if (e.code == 4902) {
      print('Network not found, attempting to add...');
      await addChain();
    } else {
      print('User rejected switch or other error');
    }
  } catch (e) {
    print('Generic error during switchChain: $e');
  }
}
