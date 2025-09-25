import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:xchain_crypto/src/const.dart';

Future<Uint8List> pbkdf2Async(
  String passphrase,
  Uint8List salt,
  int iterations,
  int keyLen,
  String digest,
) async {
  var pbkdf2 = PBKDF2KeyDerivator(
    HMac(SHA256Digest(), hmac_size), // SHA-256 digest
  );
  final params = Pbkdf2Parameters(salt, iterations, keyLen);
  pbkdf2.init(params);
  final passwordBytes = utf8.encode(passphrase);
  final derivedKey = pbkdf2.process(passwordBytes);
  return derivedKey;
}
