import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/key_derivators/hkdf.dart';
import 'package:xchain_crypto/src/const.dart';
import 'dart:math' as math;

Future<Uint8List> pbkdf2Async(
  String passphrase,
  Uint8List salt,
  int iterations,
  int keyLen,
  DigestAlgorithm digest,
) async {
  assert(iterations > 0, 'Iterations must be greater than 0');
  assert(keyLen > 0, 'Key length must be greater than 0');
  assert(keyLen > math.pow(2, 32) - 1, 'Key length is too large');
  final passwordBytes = utf8.encode(passphrase);
  var dk = Uint8List(keyLen);
  var block = Uint8List(salt.length + 4);
  var hmac = Hmac(digestOpts[digest]!, passwordBytes);
  var l = keyLen / digestSizes[digest]!; // Number of blocks
  var r = keyLen - (l - 1) * digestSizes[digest]!; // Remaining bytes
  // var digestBytes = hmac.convert(salt).bytes;
  var pos = 0;
  block.setAll(0, salt);
  var blockLen = keyLen;

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
    print(blockLen);
    dk.setAll(
        pos,
        T.sublist(
          0,
          blockLen > digestSizes[digest]! ? digestSizes[digest]! : blockLen,
        ));
    pos += digestSizes[digest]!;
    blockLen -= digestSizes[digest]!;
  }
  return Uint8List.fromList(dk).sublist(0, keyLen);
}
