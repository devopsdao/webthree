library browser;

import 'src/browser/binance_wallet/dart_wrappers.dart'
    if (dart.library.io) 'package:webthree/lib/src/browser/dart_wrappers_stub.dart'
    if (dart.library.js) 'src/browser/binance_wallet/dart_wrappers.dart';

import 'src/browser/binance_wallet/javascript.dart'
    if (dart.library.io) 'src/browser/js-stub.dart'
    if (dart.library.js) 'src/browser/binance_wallet/javascript.dart'
    hide RequestArguments;

// export 'src/browser/binance_wallet/dart_wrappers.dart';
// export 'src/browser/binance_wallet/javascript.dart' hide RequestArguments;
export 'src/browser/metamask/dart_wrappers.dart';
export 'src/browser/metamask/javascript.dart' hide RequestArguments;
export 'src/browser/okx_wallet/dart_wrappers.dart';
export 'src/browser/okx_wallet/javascript.dart' hide RequestArguments;
