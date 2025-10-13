import 'package:test/test.dart';
import 'package:xchain_crypto/src/const.dart';
import 'package:xchain_crypto/src/types/xchain_types.dart';
import 'package:xchain_crypto/src/utils.dart';
import 'mocks.dart';

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
  group('Test for pbkdf2 util implementation', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Try getting a derived key using pbkdf2 with sha256', () async {
      var derivedKey = await pbkdf2Async(
        samplePassword,
        Buffer.from(sampleSalt),
        sampleIterations,
        sampleKeyLen,
        DigestAlgorithm.sha256,
      );
      expect(derivedKey, sha256MockDk);
    });

    test('Try getting a derived key size 64 using pbkdf2 with sha256',
        () async {
      var derivedKey = await pbkdf2Async(
        samplePassword,
        Buffer.from(sampleSalt),
        sampleIterations,
        64,
        DigestAlgorithm.sha256,
      );
      expect(derivedKey, sha256dk2mock);
    });

    test('Try getting a derived key size 16 using pbkdf2 with sha512',
        () async {
      var derivedKey = await pbkdf2Async(
        samplePassword,
        Buffer.from(sampleSalt),
        sampleIterations,
        16,
        DigestAlgorithm.sha512,
      );
      expect(derivedKey.buffer, sha512dkmock);
    });
  });
}
