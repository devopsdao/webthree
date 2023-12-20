import 'dart:async';

import 'package:js/js_util.dart';
import 'package:webthree/src/core/exception_utils_js.dart'
    if (dart.library.io) 'package:webthree/src/core/exception_utils_io.dart'
    if (dart.library.js) 'package:webthree/src/core/exception_utils_js.dart';

import '../../../credentials.dart';
import '../../../json_rpc.dart';
import 'credentials.dart';
import 'javascript.dart';

/// This extension provides Dart methods around the raw [DartBinanceChain] JavaScript
/// object.
///
/// Extensions include [request] to turn request promises into Dart futures or
/// [on] to turn JavaScript event handlers into convenient Dart streams.
/// To use the raw ethereum client in a high-level `Web3Client`, use
/// [asRpcService].
extension DartBinanceChain on BinanceChainWallet {
  /// Turns this raw client into an rpc client that can be used to create a
  /// `Web3Client`:
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   final bsc = window.BinanceChain;
  ///   if (bsc == null) {
  ///     print('Binance Wallet is not available');
  ///     return;
  ///   }
  ///
  ///   final client = Web3Client.custom(bsc.asRpcService());
  /// }
  /// ```
  RpcService asRpcService() => _BinanceWalletRpcService(this);

  /// Sends a raw rpc request using the injected Ethereum client.
  ///
  /// If possible, prefer using [asRpcService] to construct a high-level client
  /// instead.
  ///
  /// See also:
  ///  - the rpc documentation under https://binance-wallet.gitbook.io/binance-chain-wallet/dev/get-started
  Future<dynamic> rawRequest(String method, {Object? params}) {
    // No, this can't be simplified. Binance Wallet wants `params` to be undefined.
    final args = params == null
        ? RequestArguments(method: method)
        : RequestArguments(method: method, params: params);
    return promiseToFuture(request(args)).onError((error, stackTrace) {
      ExceptionUtils.analyzeException(error!);
    });
  }

  /// Asks the user to select an account and give your application access to it.
  Future<List<CredentialsWithKnownAddress>> requestAccounts() {
    return rawRequest('eth_requestAccounts').then((res) {
      final List<CredentialsWithKnownAddress> credentials = [];
      for (final account in res) {
        credentials.add(BinanceWalletCredentials(account as String, this));
      }
      return credentials;
    });
  }

  /// Creates a stream of raw ethereum events.
  ///
  /// The returned stream is a broadcast stream, meaning that it can be listened
  /// to multiple times.
  ///
  /// See also:
  ///  - https://docs.metamask.io/guide/ethereum-provider.html#events
  Stream<dynamic> stream(String eventName) {
    return _EventStream(this, eventName);
  }

  /// A broadcast stream emitting values when the selected chain is changed by the user.
  Stream<dynamic> get chainChanged => stream('chainChanged').cast();

  /// A broadcast stream emitting values when the selected account is changed by the user.
  Stream<dynamic> get accountsChanged => stream('accountsChanged').cast();

  /// A broadcast stream emitting values when the selected account is connected by the user.
  Stream<dynamic> get connect => stream('connect').cast();

  /// A broadcast stream emitting values when the selected account is disconnected by the user.
  Stream<dynamic> get disconnect => stream('disconnect').cast();

  /// A broadcast stream emitting values when a message is received to the connected account.
  Stream<dynamic> get message => stream('message').cast();
}

class _BinanceWalletRpcService extends RpcService {
  final BinanceChainWallet _binancechain;

  _BinanceWalletRpcService(this._binancechain);

  @override
  Future<RPCResponse> call(String function, [List? params]) {
    return _binancechain.rawRequest(function, params: params).then((res) {
      return RPCResponse(0, res);
    });
  }
}

class _EventStream extends Stream<dynamic> {
  final BinanceChainWallet _client;
  final String _eventName;

  _EventStream(this._client, this._eventName);

  @override
  bool get isBroadcast => true;

  @override
  Stream asBroadcastStream(
      {void Function(StreamSubscription subscription)? onListen,
      void Function(StreamSubscription subscription)? onCancel}) {
    return this;
  }

  @override
  StreamSubscription listen(void Function(dynamic event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final sub = _EventStreamSubscription(_client, _eventName, onData);
    // onError, onDone and cancelOnErrors are not applicable here because event
    // streams are infinite and don't transport errors.
    return sub;
  }
}

class _EventStreamSubscription implements StreamSubscription<dynamic> {
  final BinanceChainWallet _client;
  final String _eventName;
  Function(dynamic)? _onData;

  Function? _jsCallback;
  int _activePauseRequests = 0;
  bool _isCancelled = false;

  _EventStreamSubscription(
      this._client, this._eventName, Function(dynamic)? onData) {
    if (_onData != null) {
      _onData = Zone.current.bindUnaryCallback(onData!);
    }
    _resumeIfNecessary();
  }

  @override
  Future<E> asFuture<E>([E? futureValue]) {
    // Conceptionally, this should return a future completing for onDone or
    // onError. Since neither can happen for an event stream, we just never
    // complete
    return Completer<Never>().future;
  }

  @override
  Future<void> cancel() {
    if (!_isCancelled) {
      _stopListening();
      _onData = null;
      _isCancelled = true;
    }

    return Future.value();
  }

  @override
  bool get isPaused => _activePauseRequests > 0;

  @override
  void onData(void Function(dynamic data)? handleData) {
    if (_isCancelled) {
      throw StateError('Subscription has been cancelled');
    }

    // Remove the current listener, then attach the new one
    _stopListening();
    _onData =
        handleData == null ? null : Zone.current.bindUnaryCallback(handleData);
    _resumeIfNecessary();
  }

  @override
  void onDone(void Function()? handleDone) {
    // Nothing to do, event streams are never done
  }

  @override
  void onError(Function? handleError) {
    // Nothing to do, event streams don't emit errors
  }

  @override
  void pause([Future<void>? resumeSignal]) {
    if (_isCancelled) return;

    _activePauseRequests++;
    _stopListening();
    resumeSignal?.whenComplete(resume);
  }

  @override
  void resume() {
    if (_isCancelled || !isPaused) return;
    _activePauseRequests--;
    _resumeIfNecessary();
  }

  void _resumeIfNecessary() {
    if (_onData != null && !isPaused) {
      final cb = _jsCallback = allowInterop(_onData!);
      _client.on(_eventName, cb);
    }
  }

  void _stopListening() {
    final callback = _jsCallback;
    if (callback != null) {
      _client.removeListener(_eventName, callback);
    }
  }
}
