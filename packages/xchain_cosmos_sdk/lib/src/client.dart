import 'package:xchain_client/xchain_client.dart';
import 'package:xchain_cosmos_sdk/src/tendermint/client.dart';
import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/coin.dart';
import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/query.dart';
import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/query_paths.dart';
import 'package:xchain_utils/xchain_utils.dart';

abstract base class CosmosSdkClient extends BaseXchainClient {
  final DataProviders? _providers;
  final Chain _chain;
  CosmosSdkClient({
    required chain,
    required Network network,
    DataProviders? dataProviders,
    String? phrase,
    FeeBounds? feeBounds,
    RootDerivationPaths? rootDerivationPaths,
  }) : _providers = dataProviders,
       _chain = chain,
       super(chain, (
         network: network,
         phrase: phrase,
         feeBounds: feeBounds,
         rootDerivationPaths: rootDerivationPaths,
       ));

  /// Converts a denom string to an Asset object.
  ///
  /// [denom] The denom string to convert.
  ///
  /// Returns an Asset object representing the denom.
  Asset _getAssetFromDenom(String denom) {
    if (denom.contains('/')) {
      final assetstr = assetFromString(denom.toUpperCase());
      return assetstr;
    }
    return (
      chain: _chain.toUpperCase(),
      symbol: denom.toUpperCase(),
      ticker: denom.toUpperCase(),
      type: AssetType.native,
    );
  }

  /// Converts a Coin object to a Balance object.
  ///
  /// [coin] The Coin object to convert.
  ///
  /// Returns a Balance object representing the Coin.
  Balance _coinToBalance(Coin coin) {
    return Balance(
      asset: _getAssetFromDenom(coin.denom),
      amount: BaseAmount(coin.amount),
    );
  }

  /// Fetches balances for the given address and assets.
  /// If no address is provided, it uses the client's address.
  ///
  /// [address] The address to fetch balances for. If null, uses the client's address.
  @override
  Future<Balances> getBalance({
    required Address address,
    List<Asset>? assets,
  }) async {
    return await _roundRobinGetBalances(address: address, assets: assets);
  }

  /// Fetches balances from multiple data providers in a round-robin fashion.
  ///
  ///
  _roundRobinGetBalances({
    required Address address,
    List<Asset>? assets,
  }) async {
    final network = getNetwork();
    if (_providers == null ||
        _providers[network] == null ||
        _providers[network]!.isEmpty) {
      throw ArgumentError('No data providers available');
    }
    for (var provider in _providers[network]!) {
      var tendermintClient = TendermintClient(
        RpcHttpClient(endpoint: provider),
      );
      try {
        final path = createBankQueryPath(BankMethods.allBalances);
        final request = QueryAllBalanceRequest(address: address);
        final res = await tendermintClient.abciQuerry(
          data: request.encode(),
          path: path,
        );
        final response = QueryAllBalanceResponse(value: res.value!);
        final coins = response.decode();
        return coins.map((coin) => _coinToBalance(coin)).toList();
      } catch (e) {
        print('Error with provider $provider: $e');
        continue; // Try the next provider
      }
    }
    throw Exception('Failed to fetch balances from all providers');
  }

  String getPrefix();
}
