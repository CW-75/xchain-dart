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

typedef FeeRate = double;
typedef FeeRateUnit = String;
typedef FeeRateWithUnit = ({FeeRate rate, FeeRateUnit unit});
typedef FeeRates = Map<FeeOption, FeeRate>;

typedef Fee = BaseAmount;

typedef Fees = (Map<FeeOption, Fee>, {FeeType type});
typedef FeesWithRates = ({Map<FeeOption, FeeRate> rates, Fees fees});

typedef FeeBounds = ({
  int lower,
  int upper,
});

typedef FeeEstimateOption = ({String? memo, String? sender});
