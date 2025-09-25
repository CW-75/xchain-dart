import 'package:bip39/bip39.dart';

bool validatePhrase(String phrase) => validateMnemonic(phrase);

String generatePhrase([int size = 12]) {
  return generateMnemonic(strength: size == 12 ? 128 : 256);
}
