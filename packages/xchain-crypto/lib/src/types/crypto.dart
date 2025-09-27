typedef CipherParams = ({
  String iv,
});

typedef KdfParams = ({
  String prf,
  int dklen,
  String salt,
  int c,
});

typedef KeystoreCryptoField = ({
  String cipher,
  String ciphertext,
  CipherParams cipherparams,
  String kdf,
  KdfParams kdfparams,
  String mac,
});
