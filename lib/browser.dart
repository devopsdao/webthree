/// Support for using webthree with browser clients such as MetaMask.
///
/// ## Example
///
/// ```dart
// import 'dart:convert';
// import 'dart:html';
// import 'dart:typed_data';

// //conditionally import dependencies in order to support web and other platform builds from a single codebase
// import 'package:js/js.dart'
//     if (dart.library.io) 'package:webthree/lib/src/browser/js-stub.dart'
//     if (dart.library.js) 'package:js/js.dart';
// import 'package:webthree/browser.dart'
//     if (dart.library.io) 'package:webthree/lib/src/browser/dart_wrappers_stub.dart'
//     if (dart.library.js) 'package:webthree/browser.dart';
// import 'package:webthree/webthree.dart';

// @JS()
// @anonymous
// class JSrawRequestParams {
//   external String get chainId;

//   // Must have an unnamed factory constructor with named arguments.
//   external factory JSrawRequestParams({String chainId});
// }

// Future<void> main() async {
//   final eth = window.ethereum;
//   if (eth == null) {
//     print('MetaMask is not available');
//     return;
//   }

//   final client = Web3Client.custom(eth.asRpcService());
//   final credentials = await eth.requestAccount();

//   print('Using ${credentials.address}');
//   print('Client is listening: ${await client.isListeningForNetwork()}');

//   final message = Uint8List.fromList(utf8.encode('Hello from webthree'));
//   final signature = await credentials.signPersonalMessage(message);
//   print('Signature: ${base64.encode(signature)}');

//   await eth.rawRequest('wallet_switchEthereumChain',
//       params: [JSrawRequestParams(chainId: '0x507')]);
//   final String chainIDHex = await eth.rawRequest('eth_chainId') as String;
//   final chainID = int.parse(chainIDHex);
//   print('chainID: $chainID');
// }

/// ```

library browser;

export 'src/browser/dart_wrappers.dart';
export 'src/browser/javascript.dart' hide RequestArguments;
