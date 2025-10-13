import 'package:crypto/crypto.dart';

const String cipher = 'aes-128-ctr';
const String kdf = 'pbkdf2'; // Key derivation function
const String prf = 'hmac-sha256'; // Pseudorandom function
const String meta = 'xchain-keystore'; // Metadata for the keystore
const int dklen = 32; // Length of derived key in bytes
const int c = 262144; // Iterations

enum DigestAlgorithm {
  sha1,
  sha256,
  sha512,
}

const digestSizes = {
  DigestAlgorithm.sha1: 20,
  DigestAlgorithm.sha256: 32,
  DigestAlgorithm.sha512: 64,
};

const Map<DigestAlgorithm, Hash> digestOpts = {
  DigestAlgorithm.sha1: sha1,
  DigestAlgorithm.sha256: sha256,
  DigestAlgorithm.sha512: sha512,
};

enum CipherAlgorithm {
  aes128ctr,
  aes256ctr,
}

const ciphernames = {
  CipherAlgorithm.aes128ctr: 'aes-128-ctr',
  CipherAlgorithm.aes256ctr: 'aes-256-ctr',
};
