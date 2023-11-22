import 'dart:convert';

import 'package:js/js_util.dart';
import 'package:webthree/json_rpc.dart';
import 'package:webthree/src/core/exception.dart';

class ExceptionUtils {
  ExceptionUtils();

  /// Analyze Exception to throw a typed exception
  static void analyzeException(Object e) {
    // Case of Trust Wallet for example...
    if (e.runtimeType.toString() == 'NativeError') {
      if (e.toString().toLowerCase().contains('user rejected the request')) {
        throw EthereumUserRejected();
      } else {
        throw UnimplementedError(e.toString());
      }
    } else {
      final err = json.decode(json.encode(dartify(e))) as Map<String, dynamic>;
      if (err['code'] != null) {
        // Case of Metamask...
        switch (err['code']) {
          case 4001:
            throw EthereumUserRejected();
          case -32603:
            String rpcErrorData = err['message'].toString().replaceFirst(
                "[ethjs-query] while formatting outputs from RPC '{\"value\":",
                '');
            if (rpcErrorData.length - 2 > 0) {
              rpcErrorData = rpcErrorData.substring(0, rpcErrorData.length - 2);
            }
            final rpcErrorJson = json.decode(rpcErrorData);
            throw RPCError(
              rpcErrorJson['data']['code'] ?? '',
              rpcErrorJson['data']['message'] ?? '',
              rpcErrorJson['data']['data'] ?? '',
            );
          case -32601:
            throw EthereumChainSwitchNotSupported();
          default:
            if (err['message'] != null) {
              throw EthereumException(
                err['code'],
                err['message'],
                err['data'],
              );
            } else if (err['reason'] != null) {
              throw EthersException(
                err['code'],
                err['reason'],
                err,
              );
            } else {
              throw UnimplementedError(e.toString());
            }
        }
      }
      if (err['error'] != null) {
        if (err['error']
            .toString()
            .toLowerCase()
            .contains('rejected by user')) {
          throw EthereumUserRejected();
        }
        throw BinanceWalletException(
          err['error'],
        );
      }
    }
  }
}
