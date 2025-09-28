import 'dart:typed_data';
import 'package:bip39/bip39.dart';
import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';
import 'package:xchain_crypto/src/keystore.dart';
import 'package:xchain_crypto/src/random.dart';
import 'package:xchain_crypto/src/const.dart';
import 'package:xchain_crypto/src/types/xchain_types.dart';
import 'package:xchain_crypto/src/utils.dart';

/// Validates a mnemonic phrase.
bool validatePhrase(String phrase) => validateMnemonic(phrase);

/// Generates a mnemonic phrase with the specified size (12 or 24 words).
/// [size] can be either 12 or 24, default is 12.
String generatePhrase([int size = 12]) {
  return generateMnemonic(strength: size == 12 ? 128 : 256);
}

Buffer getSeed(String phrase) {
  if (!validatePhrase(phrase)) {
    throw ArgumentError('Invalid mnemonic phrase');
  }
  return Buffer.from(mnemonicToSeed(phrase));
}

String phraseToEntropy(String phrase) {
  return mnemonicToEntropy(phrase);
}

Future<Buffer> encrypt(CipherAlgorithm cipherAlgorithm, String message,
    Buffer key, Buffer iv) async {
  // This is a placeholder for the actual cipher creation logic.
  // In a real implementation, you would return an instance of a cipher.
  Cipher cipher;
  switch (cipherAlgorithm) {
    case CipherAlgorithm.aes128ctr:
      cipher = AesCtr.with128bits(macAlgorithm: MacAlgorithm.empty);
      break;
    case CipherAlgorithm.aes256ctr:
      cipher = AesCtr.with256bits(macAlgorithm: MacAlgorithm.empty);
      break;
  }
  final cr = await cipher.encrypt(
    Uint8List.fromList(
        message.codeUnits), // Placeholder for the actual data to encrypt
    secretKey: SecretKey(key.buffer),
    nonce: iv.buffer, // Nonce is used as IV in CTR mode
  );
  return Buffer.from(cr.cipherText);
}

/// Encrypts a mnemonic phrase to a keystore format.
/// Returns a [Keystore] object containing the encrypted data.
/// Throws an [ArgumentError] if the phrase is invalid.
/// [phrase] is the mnemonic phrase to encrypt.
/// [password] is the password used for encryption.
///
/// example usage:
/// ```dart
/// Keystore keystore = await encryptToKeystore('your mnemonic phrase', 'your password');
/// ```
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
    salt: salt.toStringHex(),
    c: c,
  );
  final CipherParams cipherParams = (iv: iv.toStringHex());
  final dk = await pbkdf2Async(
    password,
    salt,
    c,
    dklen,
    DigestAlgorithm.sha256,
  );
  final cipherText = await encrypt(CipherAlgorithm.aes128ctr, phrase,
      Buffer.from(dk.sublist(0, 16)), Buffer.from(iv.sublist(0, 16)));
  final mac = await Blake2b(hashLengthInBytes: 32)
      .hash(dk.sublist(16, 32) + cipherText);

  final KeystoreCryptoField kCrypto = (
    cipher: cipher,
    ciphertext: cipherText.toStringHex(),
    cipherparams: cipherParams,
    kdf: kdf,
    kdfparams: kdfParams,
    mac: Buffer.from(mac.bytes)
        .toStringHex(), // Placeholder for MAC, should be calculated
  );
  final Keystore keystore = Keystore(
    crypto: kCrypto,
    id: id,
    version: 1, // Version of the keystore format
    meta: meta, // Metadata for the keystore
  );
  return keystore;
}

/// Decrypts a keystore to retrieve the original mnemonic phrase.
/// Returns the decrypted phrase as a [String].
/// Throws an [Exception] if the password is incorrect or the keystore is invalid.
/// [keystore] is the Keystore object containing the encrypted data.
/// [password] is the password used for decryption.
/// example usage:
Future<String> decryptFromKeystore(Keystore keystore, String password) async {
  final kdfParams = keystore.crypto.kdfparams;
  final salt = Buffer.fromHex(kdfParams.salt);
  final iv = Buffer.fromHex(keystore.crypto.cipherparams.iv);
  final dk = await pbkdf2Async(
    password,
    salt,
    kdfParams.c,
    kdfParams.dklen,
    DigestAlgorithm.sha256,
  );
  final cipherText = Buffer.fromHex(keystore.crypto.ciphertext);
  final mac = await Blake2b(hashLengthInBytes: dklen)
      .hash(dk.sublist(16, 32) + cipherText);
  if (Buffer.from(mac.bytes).toStringHex() != keystore.crypto.mac) {
    throw Exception('Invalid password');
  }
  final clearCyphertext = await encrypt(
      CipherAlgorithm.aes128ctr,
      String.fromCharCodes(cipherText.buffer),
      Buffer.from(dk.sublist(0, 16)),
      Buffer.from(iv.sublist(0, 16)));

  return String.fromCharCodes(
      clearCyphertext.buffer); // Convert to string for simplicity
}
