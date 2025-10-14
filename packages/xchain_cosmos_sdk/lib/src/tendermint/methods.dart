enum TendermintMethod {
  abciInfo,
  abciQuery,
  block,
  blockByHeight,
  broadcastTxSync,
  broadcastTxAsync,
  broadcastTxCommit,
  commit,
  healthz,
  nodeInfo,
  status,
  tx,
  txSearch,
}

extension TendermintMethodExtension on TendermintMethod {
  String get name {
    switch (this) {
      case TendermintMethod.abciInfo:
        return 'abci_info';
      case TendermintMethod.abciQuery:
        return 'abci_query';
      case TendermintMethod.block:
        return 'block';
      case TendermintMethod.blockByHeight:
        return 'block_by_height';
      case TendermintMethod.broadcastTxSync:
        return 'broadcast_tx_sync';
      case TendermintMethod.broadcastTxAsync:
        return 'broadcast_tx_async';
      case TendermintMethod.broadcastTxCommit:
        return 'broadcast_tx_commit';
      case TendermintMethod.commit:
        return 'commit';
      case TendermintMethod.healthz:
        return 'healthz';
      case TendermintMethod.nodeInfo:
        return 'node_info';
      case TendermintMethod.status:
        return 'status';
      case TendermintMethod.tx:
        return 'tx';
      case TendermintMethod.txSearch:
        return 'tx_search';
    }
  }
}
