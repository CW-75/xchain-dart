import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/key_derivators/hkdf.dart';
import 'package:xchain_crypto/src/const.dart';

Future<Uint8List> pbkdf2Async(
  String passphrase,
  Uint8List salt,
  int iterations,
  int keyLen,
  DigestAlgorithm digest,
) async {
  assert(iterations > 0, 'Iterations must be greater than 0');
  assert(keyLen > 0, 'Key length must be greater than 0');

  final passwordBytes = utf8.encode(passphrase);
  var dk = Uint8List(keyLen);
  var block = Uint8List(salt.length + 4);
  var hmac = Hmac(digestOpts[digest]!, passwordBytes);
  var l = digestSizes[digest]! ~/ keyLen; // Number of blocks
  // var digestBytes = hmac.convert(salt).bytes;
  print(hmac.toString());
  block.setAll(0, salt);
  var despos = 0;
  for (var i = 1; i <= l; i++) {
    // Prepare the block
    block.buffer.asByteData().setUint32(salt.length, i);
    // print('Block: ${block.map((e) => e.toRadixString(16)).toList()}');
    // Compute the HMAC for the block
    var T = hmac.convert(block).bytes;
    var U = T;
    print(T.length);

    // XOR with previous result if not the first block
    for (var j = 1; j < iterations; j++) {
      U = hmac.convert(U).bytes;

      for (var k = 0; k < digestSizes[digest]!; k++) {
        T[k] ^= U[k];
      }
    }
    dk.setAll(0, T);
  }
  return Uint8List.fromList(dk);
}
