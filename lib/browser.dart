library browser;

export 'package:webthree/src/browser/binance_wallet/dart_wrappers.dart'
    if (dart.library.io) 'package:webthree/src/browser/binance_wallet/dart_wrappers_stub.dart'
    if (dart.library.js) 'package:webthree/src/browser/binance_wallet/dart_wrappers.dart';

export 'package:webthree/src/browser/binance_wallet/javascript.dart'
    if (dart.library.io) 'package:webthree/src/browser/js_stub.dart'
    if (dart.library.js) 'package:webthree/src/browser/binance_wallet/javascript.dart'
    hide RequestArguments;

export 'package:webthree/src/browser/metamask/dart_wrappers.dart'
    if (dart.library.io) 'package:webthree/src/browser/metamask/dart_wrappers_stub.dart'
    if (dart.library.js) 'package:webthree/src/browser/metamask/dart_wrappers.dart';

export 'package:webthree/src/browser/metamask/javascript.dart'
    if (dart.library.io) 'package:webthree/src/browser/js_stub.dart'
    if (dart.library.js) 'package:webthree/src/browser/metamask/javascript.dart'
    hide RequestArguments;

export 'package:webthree/src/browser/okx_wallet/dart_wrappers.dart'
    if (dart.library.io) 'package:webthree/src/browser/okx_wallet/dart_wrappers_stub.dart'
    if (dart.library.js) 'package:webthree/src/browser/okx_wallet/dart_wrappers.dart';

export 'package:webthree/src/browser/okx_wallet/javascript.dart'
    if (dart.library.io) 'package:webthree/src/browser/js_stub.dart'
    if (dart.library.js) 'package:webthree/src/browser/okx_wallet/javascript.dart'
    hide RequestArguments;
