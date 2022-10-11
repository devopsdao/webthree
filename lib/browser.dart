/// Support for using webthree with browser clients such as MetaMask.
///
/// ## Example
///
/// ```dart
/// import 'dart:convert';
/// import 'dart:html';
/// import 'dart:typed_data';
///
/// import 'package:webthree/browser.dart';
/// import 'package:webthree/webthree.dart';
///
/// Future<void> main() async {
///   final eth = window.ethereum;
///   if (eth == null) {
///     print('MetaMask is not available');
///     return;
///   }
///
///   final client = Web3Client.custom(eth.asRpcService());
///   final credentials = await eth.requestAccount();
///
///   print('Using ${credentials.address}');
///   print('Client is listening: ${await client.isListeningForNetwork()}');
///
///   final message = Uint8List.fromList(utf8.encode('Hello from webthree'));
///   final signature = await credentials.signPersonalMessage(message);
///   print('Signature: ${base64.encode(signature)}');
/// }
/// ```

library browser;

export 'src/browser/dart_wrappers.dart';
export 'src/browser/javascript.dart' hide RequestArguments;
