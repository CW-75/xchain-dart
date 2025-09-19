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

abstract base class BaseXchainClient implements _XchainClient {
  Network _network;
  final String _chain;

  String? _phrase;
  final RootDerivationPaths? _derivationPaths;

  /// Set or update the network for the client.
  /// [network] The network to set for the client.
  @override
  void setNetwork(Network network) => {
        _network = network,
        if (network == Network.stagenet)
          {
            print(
                'WARNING: This is using stagenet! Real assets are being used!')
          }
      };

  /// Get the current network.
  /// Returns the current network of the client.
  @override
  Network getNetwork() => _network;

  /// Set or update the mnemonic phrase.
  ///
  /// [phrase] The mnemonic phrase to set for the client.
  /// [walletIndex] (Optional) The HD wallet index.
  /// Returns the address derived from the phrase.
  /// Throws [ArgumentError] if the phrase is invalid.
  @override
  Address setPhrase(String phrase, [int walletIndex = 0]) {
    if (validatePhrase(phrase)) {
      throw ArgumentError('Invalid phrase');
    }
    return getAddress(walletIndex);
  }

  /// Get the full derivation path for the given wallet index.
  ///
  /// [walletIndex] (Optional) The HD wallet index.
  /// Returns the full derivation path as a string.
  String getFullDerivationPath([walletIndex = 0]) =>
      '${_derivationPaths?[_network]}${walletIndex.toString()}';

  Future<FeeRateWithUnit> getFeeRate() async {
    var feeRate = await _getFeeRateFromThorchain();
    return feeRate;
  }

  /// Get the fee rate from the Thorchain API.
  ///
  /// returns The fee rate in the expected unit for each chain type.
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

  /// Get the asset information for a specific asset.
  dynamic _thornodeApiGet(String endpoint) async {
    var url = Uri.https(thornodeApis[_network]!, '/thorchain/$endpoint');
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }

  /// Purge the client by clearing the mnemonic phrase.
  @override
  void purgeClient() {
    _phrase = null;
  }

  /// Constructor for BaseXchainClient.
  ///
  /// [chain] The blockchain chain identifier.
  /// [params] Optional parameters for the client, including network, phrase, and derivation paths.
  /// Throws [ArgumentError] if the phrase is null or empty, or if the phrase format is invalid
  BaseXchainClient(String chain, [XchainClientParams? params])
      : _chain = chain,
        _network = params?.network ?? Network.testnet,
        _phrase = params?.phrase,
        _derivationPaths = params?.rootDerivationPaths {
    if (_phrase == null || _phrase!.isEmpty) {
      throw ArgumentError('Phrase cannot be null or empty');
    }
    if (!validatePhrase(_phrase!)) {
      throw ArgumentError('Invalid phrase format');
    }
  }
}
