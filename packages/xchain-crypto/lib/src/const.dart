const String cipher = 'aes-128-ctr';
const String kdf = 'pbkdf2'; // Key derivation function
const String prf = 'hmac-sha256'; // Pseudorandom function
const int c = 262144; // Iterations
const int hmac_size = 64; // Size of HMAC output in bytes