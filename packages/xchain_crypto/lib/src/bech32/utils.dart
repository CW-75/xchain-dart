import 'dart:typed_data';

import 'package:xchain_crypto/src/bech32/bech32.dart';
import 'package:xchain_crypto/src/bech32/types.dart';

/// Checks if the input string contains a Bech32 separator.
///
/// The Bech32 separator is the character '1'.
/// [input] is the string to check
bool hasBech32Separator(String input) {
  return input.contains("1");
}

/// Converts a Bech32 address to a [Bech32Decoded] object.
///
/// The function decodes the Bech32 address and returns a tuple containing the prefix and the data.
/// If the address is invalid or does not contain a Bech32 separator, it throws an [ArgumentError].
/// [address] is the Bech32 address to decode.
/// [limit] is an optional parameter that can be used to limit the length of the data
Bech32Decoded fromBech32(String address, [limit = double.infinity]) {
  // This extra check can be removed once
  // https://github.com/paulmillr/scure-base/pull/45 is merged and published.
  if (!hasBech32Separator(address)) {
    throw ArgumentError('Invalid Bech32 address: $address');
  }
  final decodedAddress = bech32.decode(address);
  return (
    prefix: decodedAddress.hrp,
    data: Uint8List.fromList(decodedAddress.data),
  );
}

/// Converts a [Bech32] object to a Bech32 address string.
///
/// The function encodes the Bech32 object and returns a string representation.
/// [prefix] is the human-readable part of the Bech32 address.
/// [data] is the data part of the Bech32 address.
String toBech32(String prefix, Uint8List data) {
  return bech32.encode(Bech32(prefix, data));
}
