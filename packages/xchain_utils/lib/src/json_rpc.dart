import 'dart:convert';

/// Interface for JSON-RPC requests.
interface class JsonRpcRequest {
  final String jsonRpc = '2.0';
  final dynamic id;
  final String method;
  final dynamic params;

  JsonRpcRequest({this.id, required this.method, this.params}) {
    if (id is! String && id is! int) {
      throw ArgumentError('id must be a String or an int');
    }
  }

  @override
  String toString() => '{'
      '"jsonrpc": "$jsonRpc", '
      '"id": ${id is String ? '"$id"' : '$id'} ,'
      '"method": "$method", '
      '"params": $params'
      '}';
}

/// Interface for JSON-RPC responses.
interface class JsonRpcResponse {
  late String jsonRpc;
  late dynamic id;
  late dynamic result;
  late dynamic error;

  /// Parses a JSON-RPC response string.
  /// [jsonResponse] is the JSON string to parse.
  /// Throws an [ArgumentError] if the response is invalid.
  JsonRpcResponse(String jsonResponse) {
    var json = jsonDecode(jsonResponse);
    jsonRpc = json['jsonrpc'] ?? '2.0';
    id = json['id'];
    if (id is! String && id is! int) {
      throw ArgumentError('id must be a String or an int');
    }
    result = json['result'];
    error = json['error'];
  }

  @override
  String toString() => '{'
      '"jsonrpc": "$jsonRpc", '
      '"id": ${id is String ? '"$id"' : '$id'}, '
      '"result": $result, '
      '"error": $error'
      '}';
}
