import 'dart:ffi';
import 'dart:typed_data';

import 'package:xchain_utils/src/bin_utils/utf8_utils.dart';
import 'package:xchain_utils/src/bin_utils/varint.dart';

/// Interface for binary reader.
/// [buffer] is the source buffer.
/// [position] is the current read position in the buffer.
/// [type] is the type of the data being read.
/// [len] is the length of the data to read.
/// [assertBounds] checks if the current position is within bounds of the buffer.
abstract interface class IBinaryReader {
  late Uint8List buffer;
  late int position;
  late int type;
  late int len;
  void assertBounds();
}

/// Binary reader class to read binary data from a buffer.
final class BinaryReader implements IBinaryReader {
  Uint8List buffer;
  int position = 0;
  int type = 0;
  int len;

  BinaryReader([Uint8List? buf])
      : buffer = buf ?? Uint8List(0),
        len = buf?.length ?? 0;

  void assertBounds() {
    if (position > len) {
      throw RangeError('premature EOF');
    }
  }

  @Uint32()
  int uint32() {
    return varint32read(this);
  }

  @Int32()
  int int32() {
    return uint32() | 0;
  }

  Uint8List bytes() {
    var len = uint32();
    var start = position;
    position += len;
    assertBounds();
    return buffer.sublist(start, start + len);
  }

  bool boolean() {
    Varint64 var64 = varint64read(this);
    return var64.lo != 0 || var64.hi != 0;
  }

  String string() {
    Uint8List bytes = this.bytes();
    return utf8Read(bytes, 0, bytes.length);
  }

  BinaryReader skip([int? length]) {
    if (length != null) {
      if (position + length > len) {
        throw RangeError('premature EOF');
      }
      position += length;
    } else {
      do {
        if (position >= len) {
          throw RangeError('premature EOF');
        }
      } while (buffer[position++] & 128 != 0);
    }

    return this;
  }

  BinaryReader skipType(int wireType) {
    switch (wireType) {
      case 0: // Varint
        skip();
        break;
      case 1: // Fixed64
        skip(8);
        break;
      case 2: // WireType bytes
        skip(uint32());
        break;
      case 3:
        while ((wireType = uint32() & 7) != 4) {
          skipType(wireType);
        }
        break;
      case 5: // Fixed32
        skip(4);
        break;
    }
    return this;
  }
}
