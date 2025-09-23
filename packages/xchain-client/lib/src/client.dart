import 'package:xchain_client/xchain_client.dart';
import 'package:xchain_utils/xchain_utils.dart';

abstract interface class XchainClient {
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

abstract class BaseClient implements XchainClient {
  Network _network = Network.mainnet;
  FeeBounds _feeBounds;
  String _chain;
  String _phrase;

  @override
  void setNetwork(Network network) => _network = network;

  @override
  Network getNetwork() => _network;

  BaseClient(this._chain, this._network, this._feeBounds, this._phrase);
}
