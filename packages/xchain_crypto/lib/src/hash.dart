import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
import 'package:xchain_crypto/src/types/buffer.dart';

/// Computes the RIPEMD-160 hash of the given [buffer].
/// The RIPEMD-160 algorithm is a cryptographic hash function that produces a 160-bit hash
/// from the input data.
/// [buffer] is expected to be a [Uint8List] or similar byte representation.
///
/// Returns a [Buffer] containing the RIPEMD-160 hash of the input data.
Buffer hash160(Uint8List buffer) {
  final sha256 = Digest('SHA-256');
  final sha256Hash = sha256.process(buffer);
  final digest = Digest('RIPEMD-160');
  return Buffer.from(digest.process(sha256Hash));
}
