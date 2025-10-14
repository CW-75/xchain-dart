import 'package:xchain_cosmos_sdk/src/tendermint/client.dart';
import 'package:test/test.dart';
import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/coin.dart';
import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/query.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      TendermintClient client = TendermintClient.connect(
        endpoint: 'https://cosmos-rpc.publicnode.com',
        // endpoint: 'https://rpc.ninerealms.com',
      );
      var address = 'cosmos1meq6c9m3qyc4vfepgcrx4suyxsa3ec4c0haxv7';
      // var address = 'thor1n7rqhtw9aek3e6j84ee9xjnxz729n0nvk86p0r';
      // print(hexlify(Uint8List.fromList(address.codeUnits)));
      // print('Address: ${Uint32List.fromList(address.codeUnits).lengthInBytes}');
      QueryAllBalanceRequest request = QueryAllBalanceRequest(address: address);

      // print('${writer.finish()}');

      var info = await client.abciQuerry(
        path: '/cosmos.bank.v1beta1.Query/AllBalances',
        data: request.encode(),
      );
      QueryAllBalanceResponse response = QueryAllBalanceResponse(
        buff: info.value!,
      );
      List<Coin> coins = response.decode();
      for (var coin in coins) {
        print('Coin: ${coin.denom}, Amount: ${coin.amount}');
      }
    });
  });
}
