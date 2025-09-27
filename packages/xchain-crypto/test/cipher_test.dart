// import 'package:xchain_crypto/xchain_crypto.dart';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';
import 'package:xchain_crypto/src/const.dart';
import 'package:xchain_crypto/src/crypto.dart';
import 'package:xchain_crypto/src/extension.dart';
import 'package:xchain_crypto/src/types/buf.dart';
import 'package:xchain_crypto/src/utils.dart';

import 'mocks.dart';
// import 'package:dotenv/dotenv.dart';

void main() {
  var sampleSalt = [
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
    0x07,
    0x08,
    0x09,
    0x0A,
    0x0B,
    0x0C,
    0x0D,
    0x0E,
    0x0F,
    0x10,
    0x11,
    0x12,
    0x13,
    0x14,
    0x15,
    0x16,
    0x17,
    0x18,
    0x19,
    0x1A,
    0x1B,
    0x1C,
    0x1D,
    0x1E,
    0x1F,
    0x20
  ];
  var sampleIterations = 262144;
  var sampleKeyLen = 32;
  var samplePassword = 'ThisIsASecret';
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('cipher aes-128-ctr', () async {
      var derivedKey = await pbkdf2Async(
        samplePassword,
        Buffer.from(sampleSalt),
        sampleIterations,
        sampleKeyLen,
        DigestAlgorithm.sha256,
      );
      expect(derivedKey.buffer, sha256MockDk);

      var iv = Buffer.from(
        List.generate(32, (index) => index + 1),
      ); // Example IV
      var cipherText = await encrypt(CipherAlgorithm.aes128ctr, 'hello world',
          derivedKey.sublist(0, 16), iv.sublist(0, 16));

      print(cipherText.toStringHex());
      print(cipherText.buffer.toString());

      var macbytes = await Blake2b(hashLengthInBytes: 32)
          .hash(derivedKey.sublist(16, 32) + cipherText);
      print(macbytes.bytes
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join());
    });

    test('cipher aes-256-ctr', () async {
      var derivedKey = await pbkdf2Async(
        samplePassword,
        Buffer.from(sampleSalt),
        sampleIterations,
        sampleKeyLen,
        DigestAlgorithm.sha256,
      );
      expect(derivedKey.buffer, sha256MockDk);

      var iv = Buffer.from(
        List.generate(16, (index) => index + 1),
      ); // Example IV
      var cipherText = await encrypt(
          CipherAlgorithm.aes256ctr, 'hello_world', derivedKey, iv);

      print(cipherText.toStringHex());
    });
  });
}
