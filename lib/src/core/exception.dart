/// Exception thrown when an the server returns an error code to an rpc request.
class WebThreeRPCError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  const WebThreeRPCError(this.code, this.message, this.data);

  @override
  String toString() {
    return 'RPCError: got code $code with msg \"$message\".';
  }
}

class EthereumUserRejected implements Exception {
  final int code;
  final String message;
  final dynamic data;

  EthereumUserRejected(this.code, this.message, this.data);

  @override
  String toString() => 'EthereumUserRejected: User rejected the request';
}

class EthereumChainSwitchNotSupported implements Exception {
  final int code;
  final String message;
  final dynamic data;

  EthereumChainSwitchNotSupported(this.code, this.message, this.data);

  @override
  String toString() =>
      'EthereumChainSwitchNotSupported: User rejected the request';
}

class EthereumException implements Exception {
  final int code;
  final String message;
  final dynamic data;

  EthereumException(this.code, this.message, this.data);

  @override
  String toString() => 'EthereumException: $code $message';
}

class EthersException implements Exception {
  final String code;
  final String reason;
  final Map<String, dynamic> rawError;

  EthersException(this.code, this.reason, this.rawError);

  @override
  String toString() => 'EthersException: $code $reason';
}

class BinanceWalletException implements Exception {
  final String error;

  BinanceWalletException(this.error);

  @override
  String toString() => 'BinanceWalletException: $error';
}
