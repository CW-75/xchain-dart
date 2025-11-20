import 'dart:convert';

import 'package:xchain_crypto/src/address.dart';
import 'package:xchain_crypto/xchain_crypto.dart';
import 'package:test/test.dart';

void main() {
  group('Tests for Utils functions', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('get seed from phrase', () async {
      var pubkey = base64Encode(Buffer.fromHex(
          '12ee6f581fe55673a1e9e1382a0829e32075a0aa4763c968bc526e1852e78c95'));
      final data = pubKeytoRawAddress(pubkey);
      // print(toBech32('cosmos', data));
      expect(
          data,
          equals(fromBech32('cosmos1pfq05em6sfkls66ut4m2257p7qwlk448h8mysz')
              .data));
    });
  });
}
