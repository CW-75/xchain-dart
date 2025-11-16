import 'dart:typed_data';

import 'package:xchain_utils/xchain_utils.dart';

class Coin {
  String denom;
  String amount;

  Coin({required this.denom, required this.amount});

  static Coin decode(dynamic input, [int? len]) {
    if (input is! BinaryReader && input is! Uint8List) {
      throw ArgumentError(
        'Expected BinaryReader or Uint8List, got ${input.runtimeType}',
      );
    }

    var reader = input is BinaryReader ? input : BinaryReader(input);
    final buffSize = len != null ? reader.position + len : reader.len;
    late String denom;
    late String amount;
    while (reader.position < buffSize) {
      final tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          denom = reader.string();
          break;
        case 2:
          amount = reader.string();
          break;
        default:
          reader.skipType(tag & 7);
          break;
      }
    }

    return Coin(denom: denom, amount: amount);
  }

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      denom: json['denom'] as String,
      amount: json['amount'] as String,
    );
  }
}
