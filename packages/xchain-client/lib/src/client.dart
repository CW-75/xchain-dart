import 'dart:convert';
import 'package:xchain_client/src/const.dart';
import 'package:xchain_client/xchain_client.dart';
import 'package:xchain_crypto/xchain_crypto.dart';
import 'package:xchain_utils/xchain_utils.dart';
import 'package:http/http.dart' as http;

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
  Address setPhrase(String phrase, int walletIndex);
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

abstract base class BaseClient implements _XchainClient {
  Network _network;
  FeeBounds _feeBounds;
  final String _chain;

  String? _phrase;
  final RootDerivationPaths? _derivationPaths;

  @override
  void setNetwork(Network network) => _network = network;

  @override
  Network getNetwork() => _network;

  @override
  Address setPhrase(String phrase, [int walletIndex = 0]) {
    if (validatePhrase(phrase)) {
      throw ArgumentError('Invalid phrase');
    }
    return getAddress(walletIndex);
  }

  String getFullDerivationPath([walletIndex = 0]) =>
      '${_derivationPaths?[_network]}${walletIndex.toString()}';

  BaseClient(String chain, [XchainClientParams? params])
      : _chain = chain,
        _network = params?.network ?? Network.testnet,
        _phrase = params?.phrase,
        _derivationPaths = params?.rootDerivationPaths,
        _feeBounds = params?.feeBounds ?? (lower: 1, upper: infinty) {
    if (_phrase == null || _phrase!.isEmpty) {
      throw ArgumentError('Phrase cannot be null or empty');
    }
    if (!validatePhrase(_phrase!)) {
      throw ArgumentError('Invalid phrase format');
    }
  }

  Future<FeeRateWithUnit> _getFeeRate() async {
    var feeRate = await _getFeeRateFromThorchain();
    return feeRate;
  }

  Future<FeeRateWithUnit> _getFeeRateFromThorchain() async {
    List<dynamic> respData = await _thornodeApiGet('inbound_addresses');
    var inboundAddress =
        respData.where((chain) => chain['chain'] == _chain).toList();

    if (inboundAddress.isEmpty) {
      throw Exception('No inbound address found for chain $_chain');
    }

    FeeRate? gasRate = double.parse(inboundAddress.first['gas_rate'] ?? '0');
    String? gasRateUnits = inboundAddress.first['gas_rate_units'];
    switch (gasRateUnits) {
      case 'gwei':
      case 'satsperbyte':
      case 'drop':
      case 'uatom':
      case 'nAVAX':
        return (rate: gasRate, unit: gasRateUnits!);
      case 'mwei':
        return (rate: gasRate / 1e3, unit: gasRateUnits!);
      case 'centigwei':
        return (rate: gasRate / 100, unit: gasRateUnits!);
      default:
        throw ArgumentError('Unknown gas rate units: $gasRateUnits');
    }
  }

  dynamic _thornodeApiGet(String endpoint) async {
    var url = Uri.https(thornodeApis[_network]!, '/thorchain/$endpoint');
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void purgeClient() {
    _phrase = null;
  }
}
