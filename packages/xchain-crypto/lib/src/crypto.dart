import 'dart:typed_data';
import 'package:bip39/bip39.dart';
import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';
import 'package:xchain_crypto/src/extension.dart';
import 'package:xchain_crypto/src/keystore.dart';
import 'package:xchain_crypto/src/random.dart';
import 'package:xchain_crypto/src/const.dart';
import 'package:xchain_crypto/src/types/crypto.dart';
import 'package:xchain_crypto/src/utils.dart';

/// Validates a mnemonic phrase.
bool validatePhrase(String phrase) => validateMnemonic(phrase);

/// Generates a mnemonic phrase with the specified size (12 or 24 words).
/// [size] can be either 12 or 24, default is 12.
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

Future<Uint8List> encrypt(CipherAlgorithm cipherAlgorithm, String message,
    Uint8List key, Uint8List iv) async {
  // This is a placeholder for the actual cipher creation logic.
  // In a real implementation, you would return an instance of a cipher.
  Cipher cipher = AesCtr.with128bits(macAlgorithm: MacAlgorithm.empty);
  final cr = await cipher.encrypt(
    Uint8List.fromList(
        message.codeUnits), // Placeholder for the actual data to encrypt
    secretKey: SecretKey(key),
    nonce: iv, // Nonce is used as IV in CTR mode
  );
  return Uint8List.fromList(cr.cipherText);
}

Future<Keystore> encryptToKeystore(String phrase, String password) async {
  if (!validatePhrase(phrase)) {
    throw ArgumentError('Invalid mnemonic phrase');
  }
  final id = Uuid().v4();
  final salt = randomBytes(32);
  final iv = randomBytes(32);
  final KdfParams kdfParams = (
    prf: prf,
    dklen: dklen,
    salt: salt.toString(),
    c: c,
  );
  final CipherParams cipherParams = (iv: iv.toString());
  final dk = await pbkdf2Async(
    password,
    salt,
    c,
    dklen,
    DigestAlgorithm.sha256,
  );
  final cipherText = await encrypt(
      CipherAlgorithm.aes128ctr, phrase, dk.sublist(0, 16), iv.sublist(0, 16));
  final mac = await Blake2b(hashLengthInBytes: 32)
      .hash(dk.sublist(16, 32) + cipherText);

  final KeystoreCryptoField kCrypto = (
    cipher: cipher,
    ciphertext: cipherText.toStringHex(),
    cipherparams: cipherParams,
    kdf: kdf,
    kdfparams: kdfParams,
    mac: Uint8List.fromList(mac.bytes)
        .toStringHex(), // Placeholder for MAC, should be calculated
  );

  // print(jsonEncode(kCrypto));
  final Keystore keystore = Keystore(
    crypto: kCrypto,
    id: id,
    version: 1, // Version of the keystore format
    meta: meta, // Metadata for the keystore
  );

  print(keystore.toJson());

  return keystore;
}
