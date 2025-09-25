import 'dart:math';
import 'dart:typed_data';

Uint8List randomBytes(int length, [int? seed]) {
  final random = Uint8List(length);
  for (int i = 0; i < length; i++) {
    random[i] = Random(seed).nextInt(255);
  }
  return random;
}
