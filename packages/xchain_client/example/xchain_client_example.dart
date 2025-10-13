// import 'package:dotenv/dotenv.dart';
// import 'package:xchain_client/xchain_client.dart';
// import '../../xchain_utils/lib/xchain_utils.dart';

// final Asset testAsset =
//     (chain: 'ETH', symbol: 'ETH', ticker: 'ETH', type: AssetType.native);

// final class TestClient extends BaseXchainClient {
//   final Network _network;
//   final String _chain;
//   TestClient(super._chain, super.params)
//       : _network = params?.network ?? Network.testnet,
//         _chain = _chain;
//   // : _phrase = params?.phrase,
//   //   _chain = _chain;

//   @override
//   String getExplorerUrl() => _network == Network.testnet
//       ? 'https://testnet.explorer.com'
//       : 'https://mainnet.explorer.com';
//   @override
//   String getExplorerAddressUrl(Address address) =>
//       'https://testnet.explorer.com/address/$address';
//   @override
//   String getExplorerTxUrl(TxHash txHash) =>
//       'https://testnet.explorer.com/tx/$txHash';
//   @override
//   bool validateAddress(Address address) => true; // Simplified for testing
//   @override
//   Address getAddress(int? walletIndex) => 'test-address-$walletIndex';
//   @override
//   Future<Address> getAsyncAddress(int? walletIndex) async =>
//       'test-async-address-$walletIndex';
//   @override
//   Future<Balances> getBalance({
//     Address? address,
//     List<Asset>? assets,
//   }) async =>
//       [];

//   @override
//   Future<TxsPage> getTransactions(TxHistoryParams params) async =>
//       () as TxsPage;
//   @override
//   Future<Tx> getTransaction(TxHash txHash) async => () as Tx;
//   @override
//   Future<Fees> getFees(FeeEstimateOption options) async => (
//         {
//           FeeOption.average: BaseAmount('1000000000000000'),
//           FeeOption.fast: BaseAmount('2000000000000000'),
//           FeeOption.fastest: BaseAmount('3000000000000000')
//         },
//         type: FeeType.base
//       );
//   @override
//   Future<TxHash> transfer(TxParams params) async =>
//       'test-tx-hash-${params.recipient}';

//   @override
//   Future<PreparedTx> prepareTx(TxParams params) async =>
//       (rawUnsignedTx: 'prepared-tx-${params.recipient}-${params.amount}');

//   @override
//   Future<TxHash> broadcastTx(String txHex) async => 'test-broadcast-tx-$txHex';

//   @override
//   Future<FeeRateWithUnit> getFeeRate() async {
//     print(_chain);
//     if (_chain == 'test') {
//       return (rate: 0.001, unit: 'test-unit');
//     }
//     var feeRate = await super.getFeeRate();
//     return feeRate;
//   }

//   @override
//   AssetInfo getAssetInfo(Asset asset) => (asset: testAsset, decimal: 18);
// }

// void main() async {
//   DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

//   XchainClientParams params = (
//     phrase: env['SECRET_PHRASE']!,
//     rootDerivationPaths: {
//       Network.testnet: "m/44'/60'/0'/0/",
//       Network.mainnet: "m/44'/60'/0'/0/",
//       Network.stagenet: "m/44'/60'/0'/0/"
//     },
//     feeBounds: (lower: 1, upper: 10000),
//     network: Network.testnet
//   );
//   final client = TestClient('AVAX', params);
//   print('Current Network: ${client.getNetwork().name}');

//   client.setNetwork(Network.mainnet);
//   print('Current Network: ${client.getNetwork().name}');

//   var rates = await client.getFeeRate();
//   print('Fee Rates: $rates');
// }
