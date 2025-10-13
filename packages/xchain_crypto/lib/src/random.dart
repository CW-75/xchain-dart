import 'dart:math';
import 'dart:typed_data';

import 'package:xchain_crypto/src/types/xchain_types.dart';

/// Generates a random buffer of the specified length.
/// Optionally, a seed can be provided for reproducibility.
///
/// Example usage:
/// ```dart
/// Buffer randomBuf = randomBytes(16);
/// ```
///
Buffer randomBytes(int length, [int? seed]) {
  final random = Uint8List(length);
  for (int i = 0; i < length; i++) {
    random[i] = Random(seed).nextInt(255);
  }
  return Buffer.from(random);
}
