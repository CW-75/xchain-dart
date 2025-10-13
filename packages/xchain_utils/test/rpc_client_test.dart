import 'package:test/test.dart';
import 'package:xchain_utils/xchain_utils.dart';

void main() {
  group('JsonRpc testing', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('Test a succesful request from RpcHttpClient', () async {
      var json = JsonRpcRequest(
        id: '1',
        method: 'status',
        params: [],
      );
      var client = RpcHttpClient(
        endpoint: 'https://cosmos-rpc.publicnode.com',
      );

      var response = await client.execute(json);
      expect(response, isA<JsonRpcResponse>());
      expect(response.result != null, isTrue);
    });
    test('Test a failing request from RpcHttpClient', () async {
      var json = JsonRpcRequest(
        id: '1',
        method: '',
        params: [],
      );
      var client = RpcHttpClient(
        endpoint: 'https://cosmos-rpc.publicnode.com',
      );
      expect(() async => await client.execute(json), throwsA(isA<Exception>()));
    });
  });
}
