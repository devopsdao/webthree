library webthree.internal.js.creds;

import 'dart:js_interop';
import 'dart:js_util';
import 'dart:typed_data';

import 'package:webthree/webthree.dart';

import '../../../crypto.dart';
import 'javascript.dart';

class MetaMaskCredentials extends CredentialsWithKnownAddress
    implements CustomTransactionSender {
  @override
  final EthereumAddress address;
  final Ethereum ethereum;

  MetaMaskCredentials(String hexAddress, this.ethereum)
      : address = EthereumAddress.fromHex(hexAddress);

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    throw UnsupportedError('Signing raw payloads is not supported on MetaMask');
  }

  @override
  Future<Uint8List> signPersonalMessage(Uint8List payload, {int? chainId}) {
    final paramsValue = jsify([
      address.hex,
      _bytesToData(payload),
    ]);

    final responsePromise = ethereum.request(RequestArguments(
      method: 'personal_sign',
      params: paramsValue as JSAny?,
    ));

    return (responsePromise as JSPromise<JSString>)
        .toDart
        .then((JSString jsResult) => _responseToBytes(jsResult.toDart));
  }

  @override
  Future<String> sendTransaction(Transaction transaction) {
    final param = _TransactionParameters(
      from: (transaction.from ?? address).hex,
      to: transaction.to?.hex,
      gasPrice: _bigIntToQuantity(transaction.gasPrice?.getInWei),
      gas: _intToQuantity(transaction.maxGas),
      value: _bigIntToQuantity(transaction.value?.getInWei),
      data: _bytesToData(transaction.data),
    );

    final paramsValue = jsify([param]);

    final responsePromise = ethereum.request(RequestArguments(
      method: 'eth_sendTransaction',
      params: paramsValue as JSAny?,
    ));

    return (responsePromise as JSPromise<JSString>)
        .toDart
        .then((JSString jsResult) => jsResult.toDart);
  }
}

String? _bigIntToQuantity(BigInt? int) {
  return int != null ? '0x${int.toRadixString(16)}' : null;
}

String? _intToQuantity(int? int) {
  return int != null ? '0x${int.toRadixString(16)}' : null;
}

Uint8List _responseToBytes(dynamic response) {
  return hexToBytes(response as String);
}

String? _bytesToData(Uint8List? data) {
  return data != null
      ? bytesToHex(data, include0x: true, padToEvenLength: true)
      : null;
}

@JS()
@anonymous
class _TransactionParameters {
  external String? get gasPrice;
  external String? get gas;
  external String? get to;
  external String get from;
  external String? get value;
  external String? get data;

  external factory _TransactionParameters({
    required String from,
    String? gas,
    String? gasPrice,
    String? to,
    String? value,
    String? data,
  });
}
