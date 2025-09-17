import 'package:test/test.dart';
import 'package:xchain_utils/xchain_utils.dart';

void main() {
  final Asset testNativeAsset = (
    chain: 'ETH',
    symbol: 'ETH',
    ticker: 'ETH',
    type: AssetType.native,
  );

  final Asset testTokenAsset = (
    chain: 'ETH',
    symbol: 'USDT-0x1234567890abcdef',
    ticker: 'USDT',
    type: AssetType.token,
  );

  final Asset testTradeAsset = (
    chain: 'ETH',
    symbol: 'USDT-0x1234567890abcdef',
    ticker: 'USDT',
    type: AssetType.trade,
  );

  final Asset testSecuredAsset = (
    chain: 'ETH',
    symbol: 'USDT-0x1234567890abcdef',
    ticker: 'USDT',
    type: AssetType.secured,
  );

  group('Asset Test group', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Get Native asset from string', () {
      Asset asset = assetFromString('BTC.BTC');
      expect(asset.symbol, 'BTC');
      expect(asset.ticker, 'BTC');
      expect(asset.chain, 'BTC');
      expect(asset.type, AssetType.native);
      // expect(awesome.isAwesome, isTrue);
    });
    test('Get Token Asset from String', () {
      Asset asset = assetFromString('ETH.USDT-0x1234567890abcdef');
      expect(asset.symbol, 'USDT-0x1234567890abcdef');
      expect(asset.ticker, 'USDT');
      expect(asset.chain, 'ETH');
      expect(asset.type, AssetType.token);
    });
    test('Get Trade Asset from String', () {
      Asset asset = assetFromString('ETH~USDT-0x1234567890abcdef');
      expect(asset.symbol, 'USDT-0x1234567890abcdef');
      expect(asset.ticker, 'USDT');
      expect(asset.chain, 'ETH');
      expect(asset.type, AssetType.trade);
    });

    test('Get Secure Asset from string', () {
      Asset asset = assetFromString('ETH-USDT-0x1234567890abcdef');
      expect(asset.symbol, 'USDT-0x1234567890abcdef');
      expect(asset.ticker, 'USDT');
      expect(asset.chain, 'ETH');
      expect(asset.type, AssetType.secured);
    });

    test('Asset Native to String ', () {
      String assetStr = assetToString(testNativeAsset);
      expect(assetStr, 'ETH.ETH');
    });
    test('Asset Token to String ', () {
      String assetStr = assetToString(testTokenAsset);
      expect(assetStr, 'ETH.USDT-0x1234567890abcdef');
    });
    test('Asset Trade to String ', () {
      String assetStr = assetToString(testTradeAsset);
      expect(assetStr, 'ETH~USDT-0x1234567890abcdef');
    });
    test('Asset Secured to String ', () {
      String assetStr = assetToString(testSecuredAsset);
      expect(assetStr, 'ETH-USDT-0x1234567890abcdef');
    });
  });
}
