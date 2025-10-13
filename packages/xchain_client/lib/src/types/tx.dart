import 'package:xchain_client/xchain_client.dart';
import 'package:xchain_utils/xchain_utils.dart';

typedef TxHash = String;

enum TxType {
  transfer,
  unknown,
}

typedef TxTo = ({
  Address to,
  BaseAmount amount,
  Asset? asset,
});

typedef TxFrom = ({
  Address from,
  BaseAmount amount,
  Asset? asset,
});

typedef Tx = ({
  Asset asset,
  List<TxFrom> from,
  List<TxTo> to,
  DateTime date,
  TxType type,
  TxHash hash,
});

typedef TxsPage = ({
  int total,
  List<Tx> txs,
});

typedef TxHistoryParams = ({
  Address address,
  int? offset,
  int? limit,
  DateTime? startTime,
  String? asset
});

typedef PreparedTx = ({
  String rawUnsignedTx,
});

typedef TxParams = ({
  BaseAmount amount,
  Address recipient,
  int? walletIndex,
  Asset? asset,
  String? memo,
});
