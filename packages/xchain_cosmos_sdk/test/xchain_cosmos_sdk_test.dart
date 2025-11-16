import 'package:dotenv/dotenv.dart';
import 'package:xchain_client/xchain_client.dart';
import 'package:xchain_cosmos_sdk/src/client.dart';
// import 'package:xchain_cosmos_sdk/src/tendermint/client.dart';
import 'package:test/test.dart';
// import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/coin.dart';
// import 'package:xchain_cosmos_sdk/src/tendermint/v1beta1/query.dart';
import 'package:xchain_utils/xchain_utils.dart';

final class PseudoCosmosClient extends CosmosSdkClient {
  PseudoCosmosClient({
    required super.chain,
    required super.network,
    super.phrase,
    super.dataProviders,
  });
  @override
  String getPrefix() {
    // TODO: implement getPrefix
    throw UnimplementedError();
  }

  @override
  Future<TxHash> broadcastTx(String txHex) {
    // TODO: implement broadcastTx
    throw UnimplementedError();
  }

  @override
  Future<Fees> getFees(FeeEstimateOption options) {
    // TODO: implement getFees
    throw UnimplementedError();
  }

  @override
  Future<PreparedTx> prepareTx(TxParams params) {
    // TODO: implement prepareTx
    throw UnimplementedError();
  }

  @override
  Future<TxHash> transfer(TxParams params) {
    // TODO: implement transfer
    throw UnimplementedError();
  }

  @override
  bool validateAddress(Address address) {
    // TODO: implement validateAddress
    throw UnimplementedError();
  }

  @override
  Address getAddress(int? walletIndex) {
    // TODO: implement getAddress
    throw UnimplementedError();
  }

  @override
  AssetInfo getAssetInfo(Asset asset) {
    // TODO: implement getAssetInfo
    throw UnimplementedError();
  }

  @override
  String getExplorerTxUrl(TxHash txHash) {
    // TODO: implement getExplorerTxUrl
    throw UnimplementedError();
  }

  @override
  String getExplorerAddressUrl(Address address) {
    // TODO: implement getExplorerAddressUrl
    throw UnimplementedError();
  }

  @override
  Future<Address> getAsyncAddress(int? walletIndex) {
    // TODO: implement getAsyncAddress
    throw UnimplementedError();
  }

  @override
  String getExplorerUrl() {
    // TODO: implement getExplorerUrl
    throw UnimplementedError();
  }

  @override
  Future<Tx> getTransaction(TxHash txHash) {
    // TODO: implement getTransaction
    throw UnimplementedError();
  }

  @override
  Future<TxsPage> getTransactions(TxHistoryParams params) {
    // TODO: implement getTransactions
    throw UnimplementedError();
  }
}

void main() {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  group('Pseudo Cosmos SDKL client implementation test', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Create Client and get balances from rpc node', () async {
      PseudoCosmosClient client = PseudoCosmosClient(
        phrase: env['SECRET_PHRASE'],
        chain: 'THOR',
        network: Network.mainnet,
        dataProviders: {
          // Network.mainnet: ['https://cosmos-rpc.publicnode.com'],
          Network.mainnet: ['https://rpc.ninerealms.com'],
        },
      );

      final balances = await client.getBalance(
        // address: 'cosmos1meq6c9m3qyc4vfepgcrx4suyxsa3ec4c0haxv7',
        address: 'thor1n7rqhtw9aek3e6j84ee9xjnxz729n0nvk86p0r',
      );

      for (var balance in balances) {
        print(
          'Asset: ${assetToString(balance.asset)}, Amount: ${baseToAsset(balance.amount).toString()}',
        );
      }
    });
  });
}
