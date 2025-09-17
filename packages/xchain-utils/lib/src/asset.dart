/// Asset type enumeration representing different kinds of assets manage by thorchain.
enum AssetType { native, token, synth, trade, secured }

/// Represents an asset with its associated properties.
typedef Asset = ({
  String symbol,
  String ticker,
  String chain,
  AssetType type,
});

bool hasAContractAddress(String assetStr) {
  return assetStr.toLowerCase().contains('-0x');
}

AssetType getTypeFromDelimiter(String assetStr) {
  if (assetStr.contains('/')) {
    return AssetType.synth;
  } else if (assetStr.contains('.') && hasAContractAddress(assetStr)) {
    return AssetType.token;
  } else if (assetStr.contains('~')) {
    return AssetType.trade;
  } else if (assetStr.contains('-')) {
    return AssetType.secured;
  }
  return AssetType.native; // Default case
}

List<String> splitAssetStringByType(String assetStr, AssetType type) {
  print(assetStr);
  switch (type) {
    case AssetType.native:
    case AssetType.token:
      return assetStr.split('.');
    case AssetType.synth:
      return assetStr.split('/');
    case AssetType.trade:
      return assetStr.split('~');
    case AssetType.secured:
      final list = assetStr.split('-'); // Split only into two parts
      return [
        list[0],
        list.sublist(1, 3).join('-'), // Join the rest of the parts
      ]; // Placeholder, should be replaced with actual logic
  }
}

Asset assetFromString(String assetStr) {
  final type = getTypeFromDelimiter(assetStr);
  final [chain, symbol] = splitAssetStringByType(assetStr, type);
  String ticker = hasAContractAddress(assetStr) ? symbol.split('-')[0] : symbol;
  return (
    symbol: symbol,
    ticker: ticker,
    chain: chain, // Placeholder, should be replaced with actual logic
    type: type, // Placeholder, should be replaced with actual logic
  );
}

String assetToString(Asset asset) {
  switch (asset.type) {
    case AssetType.synth:
      return '${asset.chain}/${asset.symbol}';
    case AssetType.trade:
      return '${asset.chain}~${asset.symbol}';
    case AssetType.secured:
      return '${asset.chain}-${asset.symbol}';
    default:
      return '${asset.chain}.${asset.symbol}';
  }
}
