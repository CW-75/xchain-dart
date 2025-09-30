class Bignumber<T> {
  BigInt _i = BigInt.zero;
  BigInt _d = BigInt.zero;
  int _z = 0;

  _isValidvalue(T value) {
    return value is String ||
        value is int ||
        value is double ||
        value is Bignumber<T>;
  }

  _countLeftPadZeros(String value) {
    for (var i = 0; i < value.length; i++) {
      if (value[i] != '0') break;
      _z++;
    }
  }

  void _takeIntegerPart(T value) {
    if (value is String) {
      _i = BigInt.parse(value.split('.').first);
    } else if (value is int || value is double) {
      _i = BigInt.from(value as num);
    }
  }

  void _takeDecimalPart(T value) {
    if (value is String) {
      if (value.contains('.')) {
        _countLeftPadZeros(value.split('.').last);
        _d = BigInt.parse(value.split('.').last);
      } else {
        _d = BigInt.zero;
      }
    } else if (value is int || value is double) {
      if (value.toString().contains('.')) {
        _countLeftPadZeros(value.toString().split('.').last);
        _d = BigInt.parse(value.toString().split('.').last);
      } else {
        _d = BigInt.zero;
      }
    }
  }

  Bignumber(T value) {
    if (!_isValidvalue(value)) {
      print(value.runtimeType);
      // throw ArgumentError('Invalid type for Bignumber: ${value.runtimeType}');
    }
    _takeIntegerPart(value);
    _takeDecimalPart(value);
  }

  Bignumber<T> _getBnForOp(T other) {
    return other is Bignumber<T>
        ? other
        : Bignumber<T>(other); // Convert to Bignumber if not already
  }

  int _decimalEqualizeLengths(Bignumber other) {
    var decimalLengthThis = _d.toString().length + _z;
    var decimalLengthOther = other._d.toString().length + other._z;
    if ((decimalLengthOther) > decimalLengthThis) {
      _d *= BigInt.from(10).pow(decimalLengthOther - decimalLengthThis);
      decimalLengthThis = decimalLengthOther;
    } else if (decimalLengthThis > decimalLengthOther) {
      other._d *= BigInt.from(10).pow(decimalLengthThis - decimalLengthOther);
      decimalLengthOther = decimalLengthThis;
    }
    return decimalLengthThis;
  }

  Bignumber<T> operator +(T other) {
    Bignumber<T> otherValue = _getBnForOp(other);
    var decLength = _decimalEqualizeLengths(otherValue);
    _d += otherValue._d;
    if (_d.toString().length > decLength) {
      _i += BigInt.from(1);
      var decimals = _d.toString().substring(1);
      _countLeftPadZeros(decimals);
      _d = BigInt.parse(decimals);
    }
    _i += otherValue._i;
    return this;
  }

  @override
  String toString() {
    if (_d == BigInt.zero) {
      return _i.toString();
    }
    return '${_i.toString()}.${_d.toString().padLeft(_z + _d.toString().length, '0')}';
  }
}
