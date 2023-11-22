import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:js/js.dart'
    if (dart.library.io) 'package:webthree/src/browser/js_stub.dart'
    if (dart.library.js) 'package:js/js.dart';
import 'package:js/js_util.dart'
    if (dart.library.io) 'package:webthree/src/browser/js_util_stub.dart'
    if (dart.library.js) 'package:js/js_util.dart';
import 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';

//Javascript object conversion
Object mapToJsObject(Map map) {
  final object = newObject();
  map.forEach((k, v) {
    if (v is Map) {
      setProperty(object, k, mapToJsObject(v));
    } else {
      setProperty(object, k, v);
    }
  });
  return object;
}

Map jsObjectToMap(dynamic jsObject) {
  final Map result = {};
  final List keys = _objectKeys(jsObject);
  for (final dynamic key in keys) {
    final dynamic value = getProperty(jsObject, key);
    List nestedKeys = [];
    if (value is List) {
      nestedKeys = objectKeys(value);
    }
    if (nestedKeys.isNotEmpty) {
      //nested property
      result[key] = jsObjectToMap(value);
    } else {
      result[key] = value;
    }
  }
  return result;
}

List<String> objectKeys(dynamic jsObject) {
  return _objectKeys(jsObject);
}

@JS('Object.keys')
external List<String> _objectKeys(jsObject);

@JS()
@anonymous
class JSrawRequestSwitchChainParams {
  external String get chainId;

  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestSwitchChainParams({String chainId});
}

@JS()
@anonymous
class JSrawRequestAddChainParams {
  // external String get params;
  external String get chainId;
  external String get chainName;
  external Map<String, dynamic> get nativeCurrency;
  external List get rpcUrls;
  external String get blockExplorerUrls;
  external String get iconUrls;
  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestAddChainParams(
      {String chainId,
      String chainName,
      Map<String, dynamic> nativeCurrency,
      List rpcUrls,
      List blockExplorerUrls,
      List iconUrls});
}

@JS('JSON.stringify')
external String stringify(Object obj);
//javascript object conversion ends

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
  await addChain(eth);
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
  await addChain(bsc);
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
  await addChain(okx);
}

Future<void> addChain(eth) async {
  final params = <String, dynamic>{
    'chainId': '0x855456',
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
  await eth
      .rawRequest('wallet_addEthereumChain', params: [mapToJsObject(params)]);
}

Future<void> switchChain(web3client, eth) async {
  try {
    // chainIdHex = await eth.rawRequest('eth_chainId');
    final chainIdHex = await web3client.makeRPCCall('eth_chainId');
    print('current chain id $chainIdHex');
  } on Exception catch (e) {
    print('user rejected $e');
  }

  try {
    await eth.rawRequest('wallet_switchEthereumChain',
        params: [JSrawRequestSwitchChainParams(chainId: '0x855456')]);
  } on Exception catch (e) {
    final error = jsObjectToMap(e);
    if (error['code'] == 4902) {
      await addChain(eth);
    } else {
      print('user rejected $error');
    }
  }
}
