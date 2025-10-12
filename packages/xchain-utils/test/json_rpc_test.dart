import 'package:test/test.dart';
import 'package:xchain_utils/src/json_rpc.dart';
import 'package:http/http.dart' as http;

void main() {
  group('JsonRpc testing', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('Defining a BaseAmount', () async {
      var json = JsonRpcRequest(0, 'status', []);
      var response = await http.post(
          Uri.parse('https://cosmos-rpc.publicnode.com'),
          body: json.toString());
      var jsonResponse = JsonRpcResponse(response.body);
      expect(response.statusCode, 200);
      expect(jsonResponse.result != null, isTrue);
    });
  });
}
