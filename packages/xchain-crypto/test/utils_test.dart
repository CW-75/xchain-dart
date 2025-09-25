import 'package:xchain_crypto/xchain_crypto.dart';
import 'package:test/test.dart';
import 'package:dotenv/dotenv.dart';

void main() {
  group('Tests for Utils functions', () {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final phrase = env['SECRET_PHRASE'];
    setUp(() {
      // Additional setup goes here.
    });

    test('get seed from phrase', () async {
      final seed = getSeed(phrase!);
      expect(seed, isA<Buffer>());
      expect(seed.toStringHex(),
          '9ab828a8c0340315babb6d6b097dff251d02dad0ae5bae6c1de78783e709a0060f1329c4c80c3fb51a55cc6f1704fb838619e26a1194bc00ca263e0b9f68ab25');
    });
    test('get Entropy from phrase', () {
      final entropy = phraseToEntropy(phrase!);
      expect(entropy, isA<String>());
      expect(entropy, '59de6979ee28b07c136e14932be37a2a');
    });
  });
}
