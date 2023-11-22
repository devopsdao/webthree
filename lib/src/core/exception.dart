class EthereumUserRejected implements Exception {
  @override
  String toString() => 'EthereumUserRejected: User rejected the request';
}

class EthereumChainSwitchNotSupported implements Exception {
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
