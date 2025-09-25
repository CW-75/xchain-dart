import 'package:crypto/crypto.dart';

const String cipher = 'aes-128-ctr';
const String kdf = 'pbkdf2'; // Key derivation function
const String prf = 'hmac-sha256'; // Pseudorandom function
const int dklen = 32; // Length of derived key in bytes
const int c = 262144; // Iterations
const int hmac_size = 64; // Size of HMAC output in bytes

enum DigestAlgorithm {
  sha256,
  sha512,
}

const digestSizes = {
  DigestAlgorithm.sha256: 32,
  DigestAlgorithm.sha512: 64,
};

const Map<DigestAlgorithm, Hash> digestOpts = {
  DigestAlgorithm.sha256: sha256,
  DigestAlgorithm.sha512: sha512,
};
