/// Asset type enumeration representing different kinds of assets manage by thorchain.
enum AssetType { native, token, synth, trade, secured }

/// Represents an asset with its associated properties.
typedef Asset = ({
  String symbol,
  String ticker,
  String chain,
  AssetType type,
});
