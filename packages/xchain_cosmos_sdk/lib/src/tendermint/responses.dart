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

final class ResponseAbciQuery {
  final String? height;
  final int? code;
  final String? log;
  final String? info;
  final String? index;
  final String? key;
  final String? value;
  final bool? proofOps;
  final bool? proof;

  ResponseAbciQuery(Map<String, dynamic> json)
    : height = json['height'] as String?,
      code = json['code'] as int?,
      log = json['log'] as String?,
      info = json['info'] as String?,
      index = json['index'] as String?,
      key = json['key'] as String?,
      value = json['value'] as String?,
      proofOps = json['proof_ops'] as bool?,
      proof = json['proof'] as bool?;
}
