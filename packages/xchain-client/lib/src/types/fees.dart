import 'package:xchain_utils/xchain_utils.dart';

enum FeeOption {
  average,
  fast,
  fastest,
}

enum FeeType {
  base,
  perByte,
}

typedef FeeRate = int;
typedef Fee = BaseAmount;

typedef Fees = ({Map<FeeOption, Fee> options, FeeType type});
typedef FeesWithRates = ({Map<FeeOption, FeeRate> rates, Fees fees});

typedef FeeBounds = (
  int lower,
  int upper,
);
