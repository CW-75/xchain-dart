import 'dart:collection';

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

typedef Fee = BaseAmount;

typedef Fees = ({Map<FeeOption, Fee> options, FeeType type});

typedef FeeBounds = (
  int lower,
  int upper,
);
