import 'package:xchain_cosmos_sdk/src/tendermint/client.dart';
import 'package:xchain_cosmos_sdk/xchain_cosmos_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      TendermintClient client = TendermintClient.connect(
        endpoint: 'https://cosmos-rpc.publicnode.com',
      );
      var info = await client.abciInfo();
      print(info.data);
    });
  });
}
