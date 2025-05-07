library webthree.internal.js;

import 'dart:js_interop';

import 'package:meta/meta.dart';
import 'package:web/web.dart' as web;

@JS('BinanceChain')
external BinanceChainWallet? get _binanceChain;

/// Extension to load obtain the `BinanceChain` window property injected by
/// BinanceChain browser plugins.
extension GetBinanceChain on web.Window {
  /// Loads the ethereum instance provided by the browser.
  ///
  /// For more information on how to use this object with the webthree package,
  /// see the methods on [DartBinanceChain].
  // ignore: non_constant_identifier_names
  BinanceChainWallet? get BinanceChain => _binanceChain;
}

@JS()
@staticInterop
class BinanceChainWallet {}

extension BinanceChainWalletExtension on BinanceChainWallet {
  external int get chainId;
  external bool get autoRefreshOnNetworkChange;
  external set autoRefreshOnNetworkChange(bool value);
  external bool isConnected();

  /// This should not be used in user code. Use `stream(event)` instead.
  @internal
  external void on(String event, JSFunction? callback);

  /// This should not be used in user code. Use `stream(event)` instead.
  @internal
  external void removeListener(String event, JSFunction? callback);

  /// This should not be used in user code. Use `requestRaw` instead.
  @internal
  external JSPromise request(RequestArguments args);
}

@JS()
@anonymous
@internal
class RequestArguments {
  external String get method;
  external JSAny? get params;

  external factory RequestArguments({String method, JSAny? params});
}
