const thorDecimal = 8;

enum Denomination { base, asset }

final class Amount {
  String _value;
  final int? _decimal;
  final Denomination _denomination;

  get decimal => _decimal ?? thorDecimal;

  /// Creates an [Amount] with the specified [_denomination], [_value], and [_decimal].
  Amount(
    this._denomination,
    this._value,
    this._decimal,
  ) {
    _value = _formatValue(_value);
  }

  String _formatValue(String value) => value.split('_').join('');

  /// Checks if the _denomination of this amount is the same as the provided one.
  bool _isSameDenomination(Denomination den) => _denomination == den;

  /// Checks if the _decimal of this amount is the same as the provided one.
  bool _isSameDecimal(int dec) => _decimal == dec;

  /// Adds another [Amount] to this one, returning a new [Amount].
  Amount plus(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot add amounts with different denominations or different decimals');
    }
    return Amount(
      _denomination,
      (BigInt.parse(_value) + BigInt.parse(other._value)).toString(),
      _decimal,
    );
  }

  Amount minus(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot subtract amounts with different denominations or different decimals');
    }
    return Amount(
      _denomination,
      (BigInt.parse(_value) - BigInt.parse(other._value)).toString(),
      _decimal,
    );
  }

  /// Divides this [Amount] by another [Amount], returning a new [Amount].
  Amount div(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot divide amounts with different denominations or different decimals');
    }
    return Amount(
      _denomination,
      (BigInt.parse(_value) ~/ BigInt.parse(other._value)).toString(),
      _decimal,
    );
  }

  Amount mul(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot multiply amounts with different denominations or different decimals');
    }
    return Amount(
      _denomination,
      (BigInt.parse(_value) * BigInt.parse(other._value)).toString(),
      _decimal,
    );
  }

  Amount pow(int exponent) {
    return Amount(
      _denomination,
      (BigInt.parse(_value).pow(exponent)).toString(),
      _decimal,
    );
  }

  bool gt(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot compare amounts with different denominations or different decimals');
    }
    return BigInt.parse(_value) > BigInt.parse(other._value);
  }

  bool gte(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot compare amounts with different denominations or different decimals');
    }
    return BigInt.parse(_value) >= BigInt.parse(other._value);
  }

  bool lt(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot compare amounts with different denominations or different decimals');
    }
    return BigInt.parse(_value) < BigInt.parse(other._value);
  }

  bool lte(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot compare amounts with different denominations or different decimals');
    }
    return BigInt.parse(_value) <= BigInt.parse(other._value);
  }

  bool equalsTo(Amount other) {
    if (!_isSameDenomination(other._denomination) ||
        !_isSameDecimal(other._decimal ?? thorDecimal)) {
      throw ArgumentError(
          'Cannot compare amounts with different denominations or different decimals');
    }
    return BigInt.parse(_value) == BigInt.parse(other._value);
  }

  operator +(Amount other) => plus(other);
  operator -(Amount other) => minus(other);
  operator /(Amount other) => div(other);
  operator *(Amount other) => mul(other);
  operator ^(int exponent) => pow(exponent);
  operator >(Amount other) => gt(other);
  operator >=(Amount other) => gte(other);
  operator <(Amount other) => lt(other);
  operator <=(Amount other) => lte(other);

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is Amount &&
          runtimeType == other.runtimeType &&
          _value == other._value &&
          _decimal == other._decimal &&
          _denomination == other._denomination;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return _value.toString();
  }
}

/// Represents a base amount in the system, typically used for native assets.
final class BaseAmount extends Amount {
  BaseAmount(String _value, [int? _decimal = thorDecimal])
      : super(Denomination.base, _value, _decimal);

  @override
  BaseAmount plus(Amount other) =>
      BaseAmount(super.plus(other)._value, _decimal);

  @override
  BaseAmount minus(Amount other) =>
      BaseAmount(super.minus(other)._value, _decimal);

  @override
  BaseAmount div(Amount other) => BaseAmount(super.div(other)._value, _decimal);

  @override
  BaseAmount mul(Amount other) => BaseAmount(super.mul(other)._value, _decimal);

  @override
  BaseAmount pow(int exponent) =>
      BaseAmount(super.pow(exponent)._value, _decimal);
}

// / Represents an amount of a specific asset, used for token or trade assets.
final class AssetAmount extends Amount {
  @override
  final int _decimal;
  AssetAmount(String _value, this._decimal)
      : super(Denomination.asset, _value, _decimal);

  @override
  AssetAmount plus(Amount other) =>
      AssetAmount(super.plus(other)._value, _decimal);

  @override
  AssetAmount minus(Amount other) =>
      AssetAmount(super.minus(other)._value, _decimal);

  @override
  AssetAmount div(Amount other) =>
      AssetAmount(super.div(other)._value, _decimal);

  @override
  AssetAmount mul(Amount other) =>
      AssetAmount(super.mul(other)._value, _decimal);

  @override
  AssetAmount pow(int exponent) =>
      AssetAmount(super.pow(exponent)._value, _decimal);
}

/// Converts a [BaseAmount] to an [AssetAmount] based on the decimal value.
AssetAmount baseToAsset(BaseAmount amount) {
  final divider = BigInt.from(10).pow(amount._decimal ?? thorDecimal);
  final assetValue = BigInt.parse(amount._value) / divider;
  return AssetAmount(assetValue.toString(), amount._decimal ?? thorDecimal);
}

/// Converts an [AssetAmount] to a [BaseAmount] based on the decimal value.
BaseAmount assetToBase(AssetAmount amount) {
  final multiplier = BigInt.from(10).pow(amount._decimal);
  final baseValue = BigInt.parse(amount._value) * multiplier;
  return BaseAmount(baseValue.toString(), amount._decimal);
}
