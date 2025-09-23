import 'package:xchain_client/xchain_client.dart';
import 'package:xchain_utils/xchain_utils.dart';

const infinty = 9223372036854775807;

abstract interface class _XchainClient {
  void setNetwork(Network network);
  Network getNetwork();
  String getExplorerUrl();
  String getExplorerAddressUrl(Address address);
  String getExplorerTxUrl(TxHash txHash);
  bool validateAddress(Address address);
  Address getAddress(int? walletIndex);
  Future<Address> getAsyncAddress(int? walletIndex);
  String setPhrase(String phrase, int walletIndex);
  Future<Balances> getBalance({
    Address? address,
    List<Asset>? assets,
  });
  Future<TxsPage> getTransactions(TxHistoryParams params);
  Future<Tx> getTransaction(TxHash txHash);
  Future<Fees> getFees(FeeEstimateOption options);
  Future<TxHash> transfer(TxParams params);
  Future<PreparedTx> prepareTx(TxParams params);
  Future<TxHash> broadcastTx(String txHex);
  AssetInfo getAssetInfo(Asset asset);
  void purgeClient();
}

abstract class BaseClient implements _XchainClient {
  Network _network;
  FeeBounds _feeBounds;
  final String _chain;

  String? _phrase;
  final RootDerivationPaths? _derivationPaths;

  @override
  void setNetwork(Network network) => _network = network;

  @override
  Network getNetwork() => _network;

  String getDerivationPath() =>
      _derivationPaths != null ? '${_derivationPaths[_network]}' : '';

  BaseClient(this._chain,
      [this._network = Network.mainnet,
      this._phrase,
      this._derivationPaths,
      this._feeBounds = (
        lower: 1,
        upper: infinty,
      )]) {
    if (_phrase == null || _phrase!.isEmpty) {
      throw ArgumentError('Phrase cannot be null or empty');
    }
  }
}
