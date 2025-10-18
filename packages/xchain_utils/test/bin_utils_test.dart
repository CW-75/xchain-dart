import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:xchain_utils/src/bin_utils/binary_reader.dart';
import 'package:xchain_utils/xchain_utils.dart';

import 'mocks/bin_mocks.dart';

void main() {
  group('Binary encoding and decoding test', () {
    setUp(() {
      // Additional setup goes here.
    });
    var writer = BinaryWriter();
    Uint8List buffer;
    test('Basic testing Json types and http call', () async {
      writer.uint32(10);
      writer.string('cosmos1meq6c9m3qyc4vfepgcrx4suyxsa3ec4c0haxv7');
      writer.int32(-2147483648); // Max negative int32 to read
      writer.int32(2147483647); // Max negative int32 to read
      writer.int32(-5656); // Max negative int32 to read
      writer.int32(2500); // Max negative int32 to read
      writer.int32(1); // Max negative int32 to read
      writer.int32(-1); // Max negative int32 to read
      writer.boolean(true);
      writer.boolean(false);
      buffer = writer.finish();
      expect(buffer, encodedMockBytes);
    });
    test('read', () {
      buffer = Uint8List.fromList(encodedMockBytes);
      var reader = BinaryReader(buffer);
      expect(reader.uint32(), 10);
      expect(reader.string(), 'cosmos1meq6c9m3qyc4vfepgcrx4suyxsa3ec4c0haxv7');
      expect(reader.int32(), -2147483648); // Max negative int32 to read
      expect(reader.int32(), 2147483647); // Max positive int32 to read
      expect(reader.int32(), -5656); // Max negative int32 to read
      expect(reader.int32(), 2500); // Max positive int32 to read
      expect(reader.int32(), 1); // Max positive int32 to read
      expect(reader.int32(), -1); // Max negative int32 to read
      expect(reader.boolean(), true);
      expect(reader.boolean(), false);
    });
  });
}
