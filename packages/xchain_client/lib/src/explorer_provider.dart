import 'package:xchain_client/xchain_client.dart';

/// ExplorerProvider class is responsible for generating URLs for blockchain explorers.
/// It constructs explorer URLs and replaces placeholders with specific addresses or transaction IDs.
class ExplorerProvider {
  final String _explorerUrl; // The base URL of the blockchain explorer
  final String
      _explorerAddressUrlTemplate; // The template URL for address exploration
  final String
      _explorerTxUrlTemplate; // The template URL for transaction exploration

  /// Constructor for ExplorerProvider.
  ExplorerProvider(this._explorerUrl, this._explorerAddressUrlTemplate,
      this._explorerTxUrlTemplate);

  /// Get the base explorer URL.
  ///
  /// Returns the base URL of the blockchain explorer.
  String getExplorerUrl() => _explorerUrl;

  /// Get the Url for exploring a specific address.
  ///
  /// [address] The address to be explored.
  /// Returns the URL for the specified address.
  String explorerAddressUrl(Address address) => _explorerAddressUrlTemplate
      .replaceFirstMapped('%%ADDRESS%%', (m) => address);

  /// Get the Url for exploring a specific transaction.
  ///
  /// [txHash] The transaction hash to be explored.
  /// Returns the URL for the specified transaction.
  String getExplorerTxUrl(TxHash txHash) =>
      _explorerTxUrlTemplate.replaceFirstMapped('%%TX_ID%%', (m) => txHash);
}
