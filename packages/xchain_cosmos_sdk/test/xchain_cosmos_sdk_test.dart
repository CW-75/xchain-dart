import 'package:xchain_cosmos_sdk/src/tendermint/client.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
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
