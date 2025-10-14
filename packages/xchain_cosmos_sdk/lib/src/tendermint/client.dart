import 'dart:convert';
import 'dart:typed_data';

import 'package:xchain_cosmos_sdk/src/tendermint/methods.dart';
import 'package:xchain_cosmos_sdk/src/tendermint/responses.dart';
import 'package:xchain_utils/xchain_utils.dart';

class TendermintClient {
  RpcHttpClient _rpcClient;

  TendermintClient(this._rpcClient);
  factory TendermintClient.connect({
    dynamic endpoint,
    Map<String, String>? headers,
  }) {
    if (endpoint is String || endpoint is HttpEndpoint) {
      return TendermintClient(
        RpcHttpClient(endpoint: endpoint, headers: headers),
      );
    } else {
      throw ArgumentError('Invalid URL type: ${endpoint.runtimeType}');
    }
  }

  Future<ResponseAbciInfo> abciInfo() async {
    var request = JsonRpcRequest(method: TendermintMethod.abciInfo.name, id: 0);
    final response = await _rpcClient.execute(request);
    return ResponseAbciInfo(response.result['response']);
  }

  Future<ResponseAbciQuery> abciQuerry({
    required String path,
    Uint8List? data,
    int? height,
    bool prove = false,
  }) async {
    var request = JsonRpcRequest(
      method: TendermintMethod.abciQuery.name,
      params: jsonEncode({
        'path': path,
        'data': hexlify(data).replaceAll('0x', ''),
      }),
      id: 0,
    );
    final response = await _rpcClient.execute(request);
    return ResponseAbciQuery(response.result['response']);
  }
}
