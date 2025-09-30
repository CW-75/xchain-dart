import 'package:test/test.dart';
import 'package:xchain_utils/xchain_utils.dart';

void main() {
  group('Amount testing', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('Defining a BaseAmount', () {
      BaseAmount baseAmount = BaseAmount('1000000000000000000000000000');
      expect(baseAmount.toString(), '1000000000000000000000000000');
      expect(baseAmount.decimal, thorDecimal);
      // expect(awesome.isAwesome, isTrue);
    });
    test('Sum of two BaseAmounts', () {
      BaseAmount amount1 = BaseAmount('1000000000000000000000000000000000000');
      BaseAmount amount2 = BaseAmount('2000000000000000000000000000000000000');
      var sum = amount1.plus(amount2);
      expect(sum.toString(), '3000000000000000000000000000000000000');
      expect((amount1 + amount2) is BaseAmount, true);
      expect(amount1 + amount2, sum);
      expect(sum.decimal, thorDecimal);
    });

    test('Defining an AssetAmount', () {
      AssetAmount assetAmount = AssetAmount('0.000000001', 8);
      expect(assetAmount.toString(), '0.000000001');
      expect(assetAmount.decimal, 8);
    });

    test('Sum of two AssetAmounts', () {
      AssetAmount amount1 = AssetAmount('0.1', 8);
      AssetAmount amount2 = AssetAmount('0.3', 8);
      AssetAmount sum = amount1.plus(amount2);
      expect(sum.toString(), '0.4');
    });
  });
  group('Amount utils functions', () {
    test('Convert Base to Asset', () {
      BaseAmount baseAmount =
          BaseAmount('10000000000000000', 18); // 0.01 ETH in wei
      AssetAmount assetAmount = baseToAsset(baseAmount);
      expect(assetAmount.toString(), '0.01');
      expect(assetAmount.decimal, 18);
    });

    test('Convert Asset to Base', () {
      AssetAmount assetAmount = AssetAmount('0.01', 18); // 0.01 ETH in wei
      BaseAmount baseAmount = assetToBase(assetAmount);
      expect(baseAmount.toString(), '10000000000000000');
      expect(baseAmount.decimal, 18);
    });
  });
}
