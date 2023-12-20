import 'dart:async';

import 'package:universal_html/html.dart';
import 'package:webthree/json_rpc.dart';

extension GetEthereum on Window {
  /// Loads the ethereum instance provided by the browser.
  ///
  /// For more information on how to use this object with the webthree package,
  /// see the methods on [DartEthereum].
  Ethereum? get ethereum => null;
}

extension DartEthereum on Ethereum {
  external bool get isMetaMask;
  external bool get isTrust;
  external int get chainId;
  external bool autoRefreshOnNetworkChange;

  /// Turns this raw client into an rpc client that can be used to create a
  /// `Web3Client`:
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   final eth = window.ethereum;
  ///   if (eth == null) {
  ///     print('MetaMask is not available');
  ///     return;
  ///   }
  ///
  ///   final client = Web3Client.custom(eth.asRpcService());
  /// }
  /// ```
  ///
  RpcService asRpcService() => _MetaMaskRpcService();

  /// Sends a raw rpc request using the injected Ethereum client.
  ///
  /// If possible, prefer using [asRpcService] to construct a high-level client
  /// instead.
  ///
  /// See also:
  ///  - the rpc documentation under https://docs.metamask.io/guide/rpc-api.html
  Future<dynamic> rawRequest(String method, {Object? params}) {
    // No, this can't be simplified. Metamask wants `params` to be undefined.
    throw UnimplementedError();
  }

  /// Asks the user to select an account and give your application access to it.
  Future<dynamic> requestAccounts() {
    throw UnimplementedError();
  }

  /// Creates a stream of raw ethereum events.
  ///
  /// The returned stream is a broadcast stream, meaning that it can be listened
  /// to multiple times.
  ///
  /// See also:
  ///  - https://docs.metamask.io/guide/ethereum-provider.html#events
  Stream<dynamic> stream(String eventName) {
    throw UnimplementedError();
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

class _MetaMaskRpcService extends RpcService {
  // final Ethereum _ethereum;

  _MetaMaskRpcService();

  @override
  Future<RPCResponse> call(String function, [List? params]) {
    throw UnimplementedError();
  }
}

class Ethereum {}
