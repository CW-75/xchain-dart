import 'package:test/test.dart';
import 'package:xchain_utils/xchain_utils.dart';

void main() {
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
  });
}
