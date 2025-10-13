import 'dart:convert';
import 'types/crypto.dart';

/// Represents a Keystore for storing cryptographic keys and metadata.
///
/// This class encapsulates the structure of a keystore, including the cryptographic fields,
///
/// example usage:
/// ```dart
/// KeystoreCryptoField cryptoField = (cipher: ....)
/// Keystore keystore = Keystore(crypto: cryptoField, id: 'unique-id', version: 1, meta: 'metadata'); // default instance
/// Keystore keystore = Keystore.fromJson(jsonDecode('{"crypto": {...}, "id": "unique-id", "version": 1, "meta": "metadata"}')); // from JSON
///```
class Keystore {
  final KeystoreCryptoField crypto;
  final String id;
  final int version;
  final String meta;

  Keystore({
    required this.crypto,
    required this.id,
    required this.version,
    required this.meta,
  });

  /// Creates a Keystore from a JSON object
  factory Keystore.fromJson(Map<String, dynamic> json) {
    return Keystore(
      crypto: (
        cipher: json['crypto']['cipher'],
        ciphertext: json['crypto']['ciphertext'],
        cipherparams: (iv: json['crypto']['cipherparams']['iv']),
        kdf: json['crypto']['kdf'],
        kdfparams: (
          prf: json['crypto']['kdfparams']['prf'],
          dklen: json['crypto']['kdfparams']['dklen'],
          salt: json['crypto']['kdfparams']['salt'],
          c: json['crypto']['kdfparams']['c'],
        ),
        mac: json['crypto']['mac']
      ),
      // Placeholder for MAC, should be calculated
      id: json['id'],
      version: json['version'],
      meta: json['meta'],
    );
  }

  // Converts the Keystore to a Map object
  Map<String, Object> toObject() {
    final cryptoFieldMap = {
      'cipher': crypto.cipher,
      'ciphertext': crypto.ciphertext,
      'cipherparams': {
        'iv': crypto.cipherparams.iv,
      },
      'kdf': crypto.kdf,
      'kdfparams': {
        'prf': crypto.kdfparams.prf,
        'dklen': crypto.kdfparams.dklen,
        'salt': crypto.kdfparams.salt,
        'c': crypto.kdfparams.c,
      },
      'mac': crypto.mac,
    };
    return {
      'crypto': cryptoFieldMap,
      'id': id,
      'version': version,
      'meta': meta,
    };
  }

  // Converts the Keystore to a JSON string
  toJson() {
    var enconder = JsonEncoder.withIndent('  ');
    return enconder.convert(toObject());
  }
}
