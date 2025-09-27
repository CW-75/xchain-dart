import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:xchain_crypto/src/crypto.dart';
import 'package:xchain_crypto/src/keystore.dart';

void main() {
  Keystore keystore;
  group('A group of tests', () {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    setUp(() {
      // Additional setup goes here.
    });

    test('Encrypt to Keystore', () async {
      keystore = await encryptToKeystore(env['SECRET_PHRASE']!, 'password123');
      expect(keystore, isA<Keystore>());
    });

    test('decrypt Keystore', () async {
      keystore = await encryptToKeystore(env['SECRET_PHRASE']!, 'password123');
      final decrypted = await decryptFromKeystore(keystore, 'password123');
      expect(decrypted, env['SECRET_PHRASE']);
      print(decrypted);
    });
  });
}
