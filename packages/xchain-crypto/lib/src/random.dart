import 'dart:math';
import 'dart:typed_data';

import 'package:xchain_crypto/src/types/buf.dart';

Buffer randomBytes(int length, [int? seed]) {
  final random = Uint8List(length);
  for (int i = 0; i < length; i++) {
    random[i] = Random(seed).nextInt(255);
  }
  return Buffer.from(random);
}
