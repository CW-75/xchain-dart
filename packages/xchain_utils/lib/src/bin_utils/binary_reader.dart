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

  String string() {
    Uint8List bytes = this.bytes();
    return utf8Read(bytes, 0, bytes.length);
  }
}
