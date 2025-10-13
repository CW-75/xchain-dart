import 'dart:typed_data';

Uint8List _getBytes(dynamic value, [String? name, bool? copy]) {
  if (value is Uint8List) {
    if (copy == true) {
      return Uint8List.fromList(value);
    }
    return value;
  }

  if (value is String && RegExp(r'^0x(?:[0-9a-f][0-9a-f])*$').hasMatch(value)) {
    Uint8List result = Uint8List((value.length - 2) ~/ 2);
    int offset = 2;
    for (int i = 0; i < result.length; i++) {
      result[i] = int.parse(value.substring(offset, offset + 2), radix: 16);
      offset += 2;
    }
    return result;
  }
  throw ArgumentError(
    'Invalid value for $name: $value. Expected Uint8List or hex string.',
  );
}

/// Get a typed Uint8List for value, If already a Uint8List the original is returned.
///
/// [value] can be a hex string or Uint8List.
/// [name] is an optional name for the value, used in error messages.
Uint8List getBytes(dynamic value, [String? name]) {
  return _getBytes(value, name, false);
}

/// Get a typed Uint8List for [value], creating a copy if necessary
/// to prevent any modifications of the returned value from being
/// reflected elsewhere.
///
/// [value] can be a hex string or Uint8List.
/// [name] is an optional name for the value, used in error messages.
Uint8List getBytesCopy(dynamic value, [String? name]) {
  return _getBytes(value, name, true);
}

/// Check if [value] is a valid hex string.
///
/// [length] is an optional length of the hex string, if provided it must match the length of the hex string.
/// If [length] is true, the hex string must have an even length.
///
/// Returns true if [value] is a valid hex string, false otherwise.
bool isHexString(dynamic value, [dynamic length]) {
  if (value is! String ||
      !RegExp(r'^0x(?:[0-9a-f][0-9a-f])*$').hasMatch(value)) {
    return false;
  }

  if (length is int && value.length != 2 + length * 2) {
    return false;
  }
  if (length == true && (value.length % 2) != 0) {
    return false;
  }
  return true;
}

/// Returns a hex string representation of the given [data].
String hexlify(dynamic data) {
  Uint8List bytes = getBytes(data);
  String result = '0x';
  for (int byte in bytes) {
    result += byte.toRadixString(16).padLeft(2, '0');
  }
  return result;
}
