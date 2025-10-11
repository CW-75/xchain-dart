import 'package:xchain_client/src/types/xchain_client_types.dart';

/// singleFee function generates a fees object with a single fee amount for all fee options.
/// [feeType] the type of fee.
/// [amount] the base fee amount to be applied to fee options.
/// Returns a Fees object with the specified fee type and a map of fee options.
Fees singleFee(FeeType feeType, Fee amount) {
  return (
    {
      FeeOption.average: amount,
      FeeOption.fast: amount,
      FeeOption.fastest: amount,
    },
    type: feeType
  );
}

/// standardFees function generates standard fees object based on a base fee amount.
/// [feeType] the type of fee.
/// [amount] the base fee amount to be applied to fee options.
/// Returns a Fees object with the specified fee type and a map of fee options.
Fees standardFees(FeeType feeType, Fee amount) {
  return (
    {
      ...singleFee(feeType, amount).$1,
      FeeOption.average: amount,
      FeeOption.fastest: amount,
    },
    type: feeType
  );
}
