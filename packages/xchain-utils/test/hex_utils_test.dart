import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:xchain_utils/src/hex_utils.dart';

void main() {
  group('Hex utils tests', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('Hexlify an buffer array', () {
      Uint8List buffer = Uint8List.fromList([15, 25, 255, 36]);
      String hexString = hexlify(buffer);
      expect(hexString, '0x0f19ff24');
    });
    test('Check if an String is an Hex', () {
      String hexString = '0x0f19ff24';
      expect(isHexString(hexString), isTrue);
      expect(isHexString(hexString, 4), isTrue);
      expect(isHexString(hexString, true), isTrue);
      expect(isHexString('Hello World'), isFalse);
    });
  });
}
