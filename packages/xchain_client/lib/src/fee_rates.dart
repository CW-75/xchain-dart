import 'package:xchain_client/src/types/fees.dart';

/// singleFeeRate function generates fee rates object with a single rate for all fee options.
/// [rate] The fee rate to be applied to all fee options.
/// Returns a FeeRates object with the specified rate for all fee options.
FeeRates singleFeeRate(FeeRate rate) {
  return {
    FeeOption.average: rate,
    FeeOption.fast: rate,
    FeeOption.fastest: rate,
  };
}

/// standardFeeRates function generates standard fee rates object based on a base rate.
/// [rate] The base fee rate to be applied to fee options.
/// Returns The fee rates object with different rates for each fee option.
FeeRates standardFeeRates(FeeRate rate) {
  return {
    ...singleFeeRate(rate),
    FeeOption.average: rate * 0.5,
    FeeOption.fastest: rate * 5.0,
  };
}

/// checkFeeBounds function checks if the given fee rate falls within predetermined feeBounds.
/// Throws an [ArgumentError] if the rate is outside the feeBounds.
/// [feeBounds] The predetermined fee rate feeBounds.
/// [rate] The fee rate to check against the bounds.
void checkFeeBounds(FeeBounds feeBounds, FeeRate rate) {
  if (rate < feeBounds.lower || rate > feeBounds.upper) {
    throw ArgumentError(
      'Fee rate $rate is outside the feeBounds of ${feeBounds.lower} and ${feeBounds.upper}',
    );
  }
}
