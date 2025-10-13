import 'package:xchain_crypto/src/types/xchain_types.dart';

abstract interface class PrivKey {
  PubKey? getPubKey();
  Buffer toBuffer();
  String toBase64();
  Buffer sign(Buffer message);
}

abstract interface class PubKey {
  Buffer getAddress();
  Buffer toBuffer();
  String toBase64();
  bool verify(Buffer signature, [Buffer? message]);
}
