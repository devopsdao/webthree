library webthree.internal.js;

import 'dart:js_interop';

import 'package:meta/meta.dart';
import 'package:web/web.dart' as web;

@JS('ethereum')
external Ethereum? get _ethereum;

extension GetEthereum on web.Window {
  Ethereum? get ethereum => _ethereum;
}

@JS()
@staticInterop
class Ethereum {}

extension EthereumExtension on Ethereum {
  external bool get isMetaMask;
  external bool get isTrust;
  external int get chainId;
  external bool get autoRefreshOnNetworkChange;
  external set autoRefreshOnNetworkChange(bool value);
  external bool isConnected();

  /// This should not be used in user code. Use `stream(event)` instead.
  @internal
  external void on(String event, JSAny? callback);

  /// This should not be used in user code. Use `stream(event)` instead.
  @internal
  external void removeListener(String event, JSAny? callback);

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
