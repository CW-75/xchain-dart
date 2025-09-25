import 'dart:typed_data';

// import 'package:bip39/bip39.dart';
import 'package:xchain_crypto/src/const.dart';
// import 'package:xchain_crypto/src/crypto.dart';
// import 'package:xchain_crypto/src/random.dart';
import 'package:xchain_crypto/src/utils.dart';
// import 'package:xchain_crypto/xchain_crypto.dart';

void main() async {
  // var phrase = generatePhrase();
  // print('Generated phrase: $phrase');
  // var isValid = validatePhrase(phrase);
  // print('Is the phrase valid? $isValid');
  // var invalidPhrase = 'this is not a valid phrase';
  // var isInvalid = validatePhrase(invalidPhrase);
  // print('Is the invalid phrase valid? $isInvalid');
  // var phrase256 = generatePhrase(24);
  // print('Generated 24-word phrase: $phrase256');

  // var _testPhrase =
  //     'motor nest wood man tonight aerobic display burger trust delay cup century';
  // var isTestPhraseValid = validatePhrase(_testPhrase);
  // print('Is the test phrase valid? $isTestPhraseValid');

  var salt = [
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
  // var phrase = const String.fromEnvironment('SECRET_PHRASE');
  // print(phrase);
  // print('Salt: $salr');
  var derivedKey = await pbkdf2Async('ThisIsASecret', Uint8List.fromList(salt),
      262144, 32, DigestAlgorithm.sha256);
  var bytes = [];
  for (var key in derivedKey) {
    bytes.add(key.toRadixString(16));
  }

  // var randomized = randomBytes(32);
  print('Derived key: ${bytes.toString()}');
  // print(randomized.map((e) => e.toRadixString(16)).toList());

  var derivedKey2 = await pbkdf2Async('ThisIsASecret', Uint8List.fromList(salt),
      262144, 64, DigestAlgorithm.sha512);
  print(derivedKey2.map((e) => e.toRadixString(16)).toList());
  // var entropy = phraseToEntropy(phrase);
  // print('Entropy: $entropy');
}
