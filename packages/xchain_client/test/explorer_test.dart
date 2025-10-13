import 'package:test/test.dart';
import 'package:xchain_client/src/explorer_provider.dart';

void main() {
  group('Test for Explorer Instatiation', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Create An explorer AVAX', () {
      ExplorerProvider explorer = ExplorerProvider(
        "https://snowtrace.io/",
        "https://snowtrace.io/address/%%ADDRESS%%",
        "https://snowtrace.io/tx/%%TX_ID%%",
      );
      expect(explorer.getExplorerUrl(), 'https://snowtrace.io/');
      expect(
          explorer
              .explorerAddressUrl('0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7'),
          'https://snowtrace.io/address/0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7');
      expect(
          explorer.getExplorerTxUrl(
              '0xc1ec830935b8378d6f251502a3543d81276319973da22b8c3434e9f4a8ec2d88'),
          'https://snowtrace.io/tx/0xc1ec830935b8378d6f251502a3543d81276319973da22b8c3434e9f4a8ec2d88');
    });
  });
}
