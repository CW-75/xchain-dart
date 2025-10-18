import 'dart:typed_data';

import 'package:xchain_cosmos_sdk/src/tendermint/client.dart';
import 'package:test/test.dart';
import 'package:xchain_utils/xchain_utils.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      TendermintClient client = TendermintClient.connect(
        endpoint: 'https://cosmos-rpc.publicnode.com',
      );
      var address = 'cosmos1meq6c9m3qyc4vfepgcrx4suyxsa3ec4c0haxv7';
      // print(hexlify(Uint8List.fromList(address.codeUnits)));
      // print('Address: ${Uint32List.fromList(address.codeUnits).lengthInBytes}');

      BinaryWriter writer = BinaryWriter();
      writer.uint32(10).string(address);

      print('${writer.finish()}');

      var info = await client.abciQuerry(
        path: '/cosmos.bank.v1beta1.Query/AllBalances',
        data: writer.finish(),
      );
    });
  });
}
