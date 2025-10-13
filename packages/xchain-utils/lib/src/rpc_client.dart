import 'package:xchain_utils/xchain_utils.dart';
import 'package:http/http.dart' as http;

abstract interface class RpcClient {
  void disconnect();
  execute(JsonRpcRequest request);
}

/// Represents an HTTP endpoint for JSON-RPC requests.
class HttpEndpoint {
  final String url;
  final Map<String, String>? headers;

  HttpEndpoint({required this.url, this.headers});
}

/// A simple HTTP client for JSON-RPC requests.
class RpcHttpClient implements RpcClient {
  late String url;
  Map<String, String>? headers;
  final int? timeout;

  /// Creates an instance of [RpcHttpClient].
  /// [endpoint] can be a [HttpEndpoint] or a [String] URL.
  /// [headers] are optional HTTP headers to include in requests.
  /// [timeout] is the optional timeout for requests in milliseconds.
  RpcHttpClient({dynamic endpoint, this.headers, this.timeout}) {
    if (endpoint is HttpEndpoint) {
      url = endpoint.url;
      headers = endpoint.headers;
    } else if (endpoint is String) {
      if (!hasProtocol(endpoint)) {
        throw ArgumentError(
          'Endpoint must include a protocol (http:// or https://)',
        );
      }
      url = endpoint;
    } else {
      throw ArgumentError('Invalid endpoint type: ${endpoint.runtimeType}');
    }
    if (timeout != null && timeout! < 0) {
      throw ArgumentError('Timeout must be a non-negative integer');
    }
  }

  @override
  void disconnect() {}

  @override
  Future<JsonRpcResponse> execute(JsonRpcRequest request) async {
    Uri uri = Uri.parse(url);
    http.Response response;
    if (timeout != null) {
      response = await http
          .post(uri, headers: headers, body: request.toString())
          .timeout(Duration(milliseconds: timeout!));
    } else {
      response =
          await http.post(uri, headers: headers, body: request.toString());
    }
    JsonRpcResponse decodedResponse = JsonRpcResponse(response.body);
    if (decodedResponse.error != null) {
      throw Exception('Error in JSON-RPC response: ${decodedResponse.error}');
    }
    return decodedResponse;
  }
}

bool hasProtocol(String url) {
  return url.contains('://');
}
