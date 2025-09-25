import 'dart:typed_data';

// Extends Uint8List to provide additional utility methods.

extension Uint8ListExtension on Uint8List {
  /// Converts the Uint8List to a hex string.
  ///
  /// Example:
  /// ```dart
  /// var bytes = Uint8List.fromList([0x01, 0x02, 0x03]);
  /// var hexString = bytes.toStringHex() // "010203"
  /// ```
  String toStringHex() {
    return map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Converts the Uint8List to a list of hex strings.
  /// /// Example:
  /// ```dart
  /// var bytes = Uint8List.fromList([0x01, 0x02, 0x03, 0xa2, 0xb3]);
  /// var hexList = bytes.toBufString() // ["01", "02", "03", "a2", "b3"]
  /// ```
  List<String> toBufString() {
    return map((byte) => byte.toRadixString(16).padLeft(2, '0')).toList();
  }

  Uint8List fromHexString(String hex) {
    if (hex.length % 2 != 0) {
      throw ArgumentError('Hex string must have an even length');
    }
    return Uint8List.fromList(
      List.generate(hex.length ~/ 2,
          (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)),
    );
  }
}
