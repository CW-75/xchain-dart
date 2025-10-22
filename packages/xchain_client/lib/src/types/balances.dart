import 'package:xchain_utils/xchain_utils.dart';

typedef Balances = List<Balance>;

final class Balance {
  Asset asset;
  BaseAmount amount;

  Balance({
    required this.asset,
    required this.amount,
  });
}
