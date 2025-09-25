import 'dart:typed_data';

import 'package:bip39/bip39.dart';
// import 'package:uuid/uuid.dart';
// import 'package:xchain_crypto/src/const.dart';
// import 'package:xchain_crypto/src/random.dart';
// import 'package:xchain_crypto/src/types/crypto.dart';

bool validatePhrase(String phrase) => validateMnemonic(phrase);

String generatePhrase([int size = 12]) {
  return generateMnemonic(strength: size == 12 ? 128 : 256);
}

Uint8List getSeed(String phrase) {
  if (!validatePhrase(phrase)) {
    throw ArgumentError('Invalid mnemonic phrase');
  }
  return mnemonicToSeed(phrase);
}

String phraseToEntropy(String phrase) {
  return mnemonicToEntropy(phrase);
}

// Future<Keystore> encryptToKeystore(String phrase, String password) async {
//   if (!validatePhrase(phrase)) {
//     throw ArgumentError('Invalid mnemonic phrase');
//   }
//   final id = Uuid().v4();
//   final salt = randomBytes(32);
//   final iv = randomBytes(16);
//   final KdfParams kdfParams = (
//     prf: prf,
//     dklen: dklen,
//     salt: salt.toString(),
//     c: c,
//   );
//   final cipherParams = (iv: iv.toString(),);
// }
