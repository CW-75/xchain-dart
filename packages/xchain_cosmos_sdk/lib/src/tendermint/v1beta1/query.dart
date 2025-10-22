import 'dart:convert';
import 'dart:typed_data';

import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/coin.dart';
import 'package:xchain_utils/xchain_utils.dart';

final class QueryAllBalanceRequest {
  String address;
  bool? resolveDenom;
  QueryAllBalanceRequest({required this.address, this.resolveDenom = true});

  Uint8List encode() {
    BinaryWriter writer = BinaryWriter();
    writer.uint32(10).string(address);
    if (resolveDenom == true) {
      writer.uint32(24).boolean(resolveDenom!);
    }
    return writer.finish();
  }
}

final class QueryAllBalanceResponse {
  final Uint8List _buff;
  QueryAllBalanceResponse({required String value})
    : _buff = base64Decode(value) {
    if (_buff.isEmpty) {
      throw ArgumentError('Buffer cannot be empty');
    }
  }

  List<Coin> decode() {
    BinaryReader reader = BinaryReader(_buff);
    List<Coin> coins = [];
    var end = reader.len;
    while (reader.position < end) {
      var tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          var coin = Coin.decode(reader, reader.int32());
          coins.add(coin);
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }
    return coins;
  }
}
