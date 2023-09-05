import 'package:webthree/src/core/exception.dart';

class ExceptionUtils {
  ExceptionUtils();

  /// Analyze Exception to throw a typed exception
  static void analyzeException(Object e) {
    if (e.toString().toLowerCase().contains('user rejected the request')) {
      throw EthereumUserRejected();
    } else {
      throw UnimplementedError(e.toString());
    }
  }
}
