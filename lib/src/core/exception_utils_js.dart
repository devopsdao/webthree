import 'dart:convert';

import 'package:js/js_util.dart';
import 'package:webthree/src/core/exception.dart';

class ExceptionUtils {
  ExceptionUtils();

  /// Analyze Exception to throw a typed exception
  static void analyzeException(Object e) {
    // Case of Trust Wallet for example...
    if (e.runtimeType.toString() == 'NativeError') {
      if (e.toString().toLowerCase().contains('user rejected the request')) {
        throw WebThreeRPCError(4001, e.toString(), '');
      }
      if (e.toString().toLowerCase().contains('unrecognized chain id')) {
        throw WebThreeRPCError(4902, e.toString(), '');
      } else {
        throw WebThreeRPCError(9991, e.toString(), '');
      }
    } else {
      final err = json.decode(json.encode(dartify(e))) as Map<String, dynamic>;
      if (err['code'] != null) {
        // Case of Metamask...
        switch (err['code']) {
          case 4001:
            throw EthereumUserRejected(
                err['code'], err['message'], err['stack']);
          case -32603:
            String rpcErrorData = err['message'].toString().replaceFirst(
                "[ethjs-query] while formatting outputs from RPC '{\"value\":",
                '');
            if (rpcErrorData.length - 2 > 0) {
              rpcErrorData = rpcErrorData.substring(0, rpcErrorData.length - 2);
            }
            try {
              final rpcErrorJson = json.decode(rpcErrorData);
              throw WebThreeRPCError(
                rpcErrorJson['data']['code'] ?? '',
                rpcErrorJson['data']['message'] ?? '',
                rpcErrorJson['data']['data'] ?? '',
              );
            } on FormatException catch (_) {
              throw WebThreeRPCError(
                err['code'] ?? '',
                err['message'] ?? '',
                err['data'] ?? '',
              );
            }

          case -32601:
            throw EthereumChainSwitchNotSupported(
                err['code'], err['message'], err['stack']);
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
              throw WebThreeRPCError(err['code'], err['message'], err['data']);
            }
        }
      }
      if (err['error'] != null) {
        if (err['error']
            .toString()
            .toLowerCase()
            .contains('rejected by user')) {
          throw EthereumUserRejected(err['code'], err['message'], err['stack']);
        }
        throw BinanceWalletException(
          err['error'],
        );
      }
    }
  }
}
