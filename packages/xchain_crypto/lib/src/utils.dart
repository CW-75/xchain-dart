import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:xchain_crypto/src/const.dart';
import 'dart:math' as math;

import 'package:xchain_crypto/src/types/xchain_types.dart';

/// Utility class for converting between different bit representations.
///
/// This class provides methods to compress and decompress lists of integers
class BitListCompressor {
  int inBits;
  int outBits;

  /// Creates a [BitListCompressor] instance with specified input and output bit sizes.
  /// /// [inBits] is the number of bits in the input integers.
  /// [outBits] is the number of bits in the output integers.
  BitListCompressor(this.inBits, this.outBits);

  /// Converts a list of integers from [inBits] to [outBits].
  ///
  /// If [pad] is true, it pads the last byte if necessary.
  /// If [pad] is false, it checks for excess padding or non-zero padding.
  /// Returns a [Uint8List] containing the compressed data.
  static Uint8List convert(List<int> data, int inBits, int outBits,
      [bool pad = false]) {
    return BitListCompressor(inBits, outBits).compress(data, pad);
  }

  /// Compresses a list of integers from [inBits] to [outBits].
  ///
  /// If [pad] is true, it pads the last byte if necessary.
  /// If [pad] is false, it checks for excess padding or non-zero padding.
  /// Returns a [Uint8List] containing the compressed data.
  Uint8List compress(List<int> data, [pad = false]) {
    var value = 0;
    var bits = 0;
    final maxV = (1 << outBits) - 1;

    final List<int> result = [];
    for (var i = 0; i < data.length; ++i) {
      value = (value << inBits) | data[i];
      bits += inBits;
      while (bits >= outBits) {
        bits -= outBits;
        result.add((value >> bits) & maxV);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((value << (outBits - bits)) & maxV);
      }
    } else {
      if (bits >= inBits) throw ArgumentError('Excess padding');
      if (((value << (outBits - bits)) & maxV) != 0) {
        throw ArgumentError('Non-zero padding');
      }
    }

    return Uint8List.fromList(result);
  }
}

///
/// Function based on https://datatracker.ietf.org/doc/html/rfc2898#section-5.2
/// Implements PBKDF2 key derivation function asynchronously.
///
Future<Buffer> pbkdf2Async(
  String passphrase,
  Buffer salt,
  int iterations,
  int keyLen,
  DigestAlgorithm digest,
) async {
  assert(iterations > 0, 'Iterations must be greater than 0');
  assert(keyLen > 0, 'Key length must be greater than 0');
  assert(keyLen < math.pow(2, 32) - 1, 'derived key too long');
  final passwordBytes = utf8.encode(passphrase);
  var dk = Uint8List(keyLen);
  var block = Uint8List(salt.length + 4);
  final Hmac hmac = Hmac(digestOpts[digest]!, passwordBytes);
  var l = keyLen / digestSizes[digest]!; // Number of blocks
  var pos = 0;
  block.setAll(0, salt.buffer);
  var dkres = keyLen;

  for (var i = 1; i <= l.ceil(); i++) {
    // Prepare the block
    block.buffer.asByteData().setUint32(salt.length, i);
    var T = hmac.convert(block).bytes;
    var U = T;
    // XOR with previous result if not the first block
    for (var j = 1; j < iterations; j++) {
      U = hmac.convert(U).bytes;
      for (var k = 0; k < digestSizes[digest]!; k++) {
        T[k] ^= U[k];
      }
    }
    dk.setAll(
        pos,
        T.sublist(
          0,
          dkres > digestSizes[digest]! ? digestSizes[digest]! : dkres,
        ));
    pos += digestSizes[digest]!;
    dkres -= digestSizes[digest]!;
  }
  return Buffer.from(dk);
}
