abstract interface class PrivKey {
  PubKey? getPubKey();
  StringBuffer toBuffer();
  String toBase64();
  StringBuffer sign(StringBuffer message);
}

abstract interface class PubKey {
  StringBuffer getAddress();
  StringBuffer toBuffer();
  String toBase64();
  bool verify(StringBuffer signature, [StringBuffer? message]);
}
