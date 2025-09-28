import 'dart:convert';
import 'dart:io'; // This test uses file operation to create and load a keystore file
import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:xchain_crypto/src/crypto.dart';
import 'package:xchain_crypto/src/keystore.dart';

void main() {
  Keystore keystore;
  group('Tests for Keystore encrypt/decrypt functionalities', () {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    setUp(() {
      // Additional setup goes here.
    });

    test('Encrypt to Keystore', () async {
      keystore = await encryptToKeystore(
          env['SECRET_PHRASE']!, env['SECRET_PASSWORD']!);
      File keystoreFile = File('keystore.json');
      keystoreFile.writeAsString(keystore.toJson());
      expect(keystore, isA<Keystore>());
      expect(keystore.crypto.cipher, 'aes-128-ctr');
      expect(keystore.crypto.kdf, 'pbkdf2');
      expect(keystore.crypto.kdfparams.prf, 'hmac-sha256');
      expect(keystore.crypto.kdfparams.dklen, 32);
      expect(keystore.crypto.kdfparams.c, 262144);
    });

    test('decrypt Keystore', () async {
      final File keystoreFile = File('keystore.json');
      final Keystore keystoreMock = Keystore.fromJson(
        jsonDecode(keystoreFile.readAsStringSync()),
      );
      final decrypted =
          await decryptFromKeystore(keystoreMock, env['SECRET_PASSWORD']!);
      expect(decrypted, env['SECRET_PHRASE']);
    });

    test('decrypt Keystore failed password', () async {
      try {
        final File keystoreFile = File('keystore.json');
        final Keystore keystoreMock = Keystore.fromJson(
          jsonDecode(keystoreFile.readAsStringSync()),
        );
        await decryptFromKeystore(keystoreMock, 'wrongpassword');
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Invalid password'));
      }
    });
  });
}
