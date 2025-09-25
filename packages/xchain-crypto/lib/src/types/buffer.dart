import 'dart:collection';
import 'dart:typed_data';

import 'package:xchain_crypto/src/extension.dart';

/// Represents a buffer of bytes, similar to Node.js Buffer.
/// Provides methods for creating buffers from lists or hex strings,
/// and for converting buffers to strings or sublists.
///
/// Example usage:
/// ```dart
/// Buffer defaultBuf = Buffer(Uint8List(10));
/// Buffer buf = Buffer.from([1, 2, 3]);
/// Buffer hexBuf = Buffer.fromHex('0a0b0c');
/// ```
class Buffer extends ListBase<int> {
  Uint8List buffer;
  // get length => buffer.length;

  @override
  int get length => buffer.length;

  @override
  set length(int newLength) {
    buffer = Uint8List(newLength);
  }

  @override
  int operator [](int index) {
    return buffer[index];
  }

  @override
  void operator []=(int index, int value) {
    buffer[index] = value;
  }

  factory Buffer.from(List<int> list) {
    return Buffer(Uint8List.fromList(list));
  }

  factory Buffer.fromHex(String hex) {
    return Buffer(Uint8List.fromList(
      List.generate(hex.length ~/ 2,
          (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)),
    ));
  }

  @override
  Buffer sublist(int start, [int? end]) => Buffer(buffer.sublist(start, end));

  @override
  String toString() {
    return buffer.toString();
  }

  String toStringHex() {
    return buffer.toStringHex();
  }

  // operator +(Buffer other) {
  //   return buffer + other.buffer;
  // }

  Buffer(this.buffer);

  @override
  operator ==(Object other) {
    if (other is Buffer) {
      return buffer == other.buffer;
    }
    return false;
  }

  @override
  get hashCode => buffer.hashCode;
}
