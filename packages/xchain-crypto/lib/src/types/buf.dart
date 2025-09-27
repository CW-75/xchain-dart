import 'dart:typed_data';

import 'package:xchain_crypto/src/extension.dart';

class Buffer {
  Uint8List buffer;
  get length => buffer.length;

  factory Buffer.from(List<int> list) {
    return Buffer(Uint8List.fromList(list));
  }

  factory Buffer.fromHex(String hex) {
    return Buffer(Uint8List.fromList(
      List.generate(hex.length ~/ 2,
          (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)),
    ));
  }

  Buffer sublist(int start, [int? end]) {
    return Buffer(buffer.sublist(start, end));
  }

  @override
  String toString() {
    return buffer.toString();
  }

  String toStringHex() {
    return buffer.toStringHex();
  }

  operator +(Buffer other) {
    return buffer + other.buffer;
  }

  Buffer(this.buffer);
}
