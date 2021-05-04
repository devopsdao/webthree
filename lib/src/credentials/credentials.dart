import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';

import '../../web3dart.dart' show Transaction;
import '../crypto/formatting.dart';
import '../crypto/keccak.dart';
import '../crypto/secp256k1.dart';
import '../crypto/secp256k1.dart' as secp256k1;
import '../utils/typed_data.dart';
import 'address.dart';

/// Anything that can sign payloads with a private key.
abstract class Credentials {
  static const _messagePrefix = '\u0019Ethereum Signed Message:\n';

  /// Whether these [Credentials] are safe to be copied to another isolate and
  /// can operate there.
  /// If this getter returns true, the client might chose to perform the
  /// expensive signing operations on another isolate.
  bool get isolateSafe => false;

  /// Loads the ethereum address specified by these credentials.
  Future<EthereumAddress> extractAddress();

  /// Signs the [payload] with a private key. The output will be like the
  /// bytes representation of the [eth_sign RPC method](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign),
  /// but without the "Ethereum signed message" prefix.
  /// The [payload] parameter contains the raw data, not a hash.
  Future<Uint8List> sign(Uint8List payload, {int? chainId}) async {
    final signature = await signToSignature(payload, chainId: chainId);

    final r = padUint8ListTo32(unsignedIntToBytes(signature.r));
    final s = padUint8ListTo32(unsignedIntToBytes(signature.s));
    final v = unsignedIntToBytes(BigInt.from(signature.v));

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L63
    return uint8ListFromList(r + s + v);
  }

  /// Signs the [payload] with a private key and returns the obtained
  /// signature.
  Future<MsgSignature> signToSignature(Uint8List payload, {int? chainId});

  /// Signs an Ethereum specific signature. This method is equivalent to
  /// [sign], but with a special prefix so that this method can't be used to
  /// sign, for instance, transactions.
  Future<Uint8List> signPersonalMessage(Uint8List payload, {int? chainId}) {
    final prefix = _messagePrefix + payload.length.toString();
    final prefixBytes = ascii.encode(prefix);

    // will be a Uint8List, see the documentation of Uint8List.+
    final concat = uint8ListFromList(prefixBytes + payload);

    return sign(concat, chainId: chainId);
  }
}

/// Credentials where the [address] is known synchronously.
abstract class CredentialsWithKnownAddress extends Credentials {
  /// The ethereum address belonging to this credential.
  EthereumAddress get address;

  @override
  Future<EthereumAddress> extractAddress() async {
    return Future.value(address);
  }
}

/// Interface for [Credentials] that don't sign transactions locally, for
/// instance because the private key is not known to this library.
abstract class CustomTransactionSender extends Credentials {
  Future<String> sendTransaction(Transaction transaction);
}

/// Credentials that can sign payloads with an Ethereum private key.
class EthPrivateKey extends CredentialsWithKnownAddress {
  final Uint8List privateKey;
  EthereumAddress? _cachedAddress;

  EthPrivateKey(this.privateKey);

  EthPrivateKey.fromHex(String hex) : privateKey = hexToBytes(hex);

  /// Creates a new, random private key from the [random] number generator.
  ///
  /// For security reasons, it is very important that the random generator used
  /// is cryptographically secure. The private key could be reconstructed by
  /// someone else otherwise. Just using [Random()] is a very bad idea! At least
  /// use [Random.secure()].
  factory EthPrivateKey.createRandom(Random random) {
    final key = generateNewPrivateKey(random);
    return EthPrivateKey(intToBytes(key));
  }

  @override
  final bool isolateSafe = true;

  @override
  EthereumAddress get address {
    return _cachedAddress ??= EthereumAddress(
        publicKeyToAddress(privateKeyBytesToPublic(privateKey)));
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId}) async {
    final signature = secp256k1.sign(keccak256(payload), privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27
    final chainIdV =
        chainId != null ? (signature.v - 27 + (chainId * 2 + 35)) : signature.v;

    return MsgSignature(signature.r, signature.s, chainIdV);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EthPrivateKey &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(privateKey, other.privateKey);

  @override
  int get hashCode => privateKey.hashCode;
}
