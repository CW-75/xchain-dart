import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:xchain_crypto/src/const.dart';
import 'dart:math' as math;

import 'package:xchain_crypto/src/types/xchain_types.dart';

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
