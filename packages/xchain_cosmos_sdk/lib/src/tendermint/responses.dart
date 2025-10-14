final class ResponseAbciInfo {
  final String? data;
  final String? version;
  final String? lastBlockHeight;
  final String? lastBlockAppHash;
  ResponseAbciInfo(Map<String, dynamic> json)
    : data = json['data'] as String?,
      version = json['version'] as String?,
      lastBlockHeight = json['last_block_height'] as String?,
      lastBlockAppHash = json['last_block_app_hash'] as String?;
}
