import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:xchain_utils/xchain_utils.dart';

void main() {
  group('JsonRpc testing', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('Basic testing Json types and http call', () async {
      var json = JsonRpcRequest(
        id: '1',
        method: 'status',
        params: [],
      );
      var response = await http.post(
          Uri.parse('https://cosmos-rpc.publicnode.com'),
          body: json.toString());
      var jsonResponse = JsonRpcResponse(response.body);
      expect(response.statusCode, 200);
      expect(jsonResponse.result != null, isTrue);
    });
  });
}
