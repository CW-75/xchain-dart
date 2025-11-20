/// Bech32 Exceptions
/// This file defines the exceptions used in the Bech32 encoding and decoding process.
enum Bech32Exception {
  tooShortHrp,
  tooLongBech32,
  outOfRange,
  mixedCases,
  outboundChars,
  invalidSeparator,
  invalidAddress,
  invalidChecksum,
  tooShortChecksum,
  invalidHrp,
  invalidProgramLength,
  invalidWitnessVersion,
  invalidPadding,
}

/// Extension on [Bech32Exception] to provide custom messages for each exception.
/// This extension allows for a more user-friendly error message when an exception is thrown.
extension Bech32Exceptions on Bech32Exception {
  String get message {
    return switch (this) {
      Bech32Exception.tooShortHrp =>
        'The human readable part should have non zero length.',
      Bech32Exception.tooLongBech32 => 'The bech32 string is too long: (>90)',
      Bech32Exception.outOfRange =>
        'The human readable part contains invalid characters.',
      Bech32Exception.mixedCases =>
        'The human readable part is mixed case, should either be all lower or all upper case.',
      Bech32Exception.outboundChars => 'A character is undefined in bech32.',
      Bech32Exception.invalidSeparator =>
        'The separator character "1" is at an invalid position.',
      Bech32Exception.invalidAddress =>
        'The address is invalid, it should be a valid bech32 address.',
      Bech32Exception.invalidChecksum => 'Checksum verification failed.',
      Bech32Exception.tooShortChecksum =>
        'The checksum is shorter than 6 characters.',
      Bech32Exception
            .invalidHrp => // This error depends of the chain for example: in btc it should be 'bc' or 'tb',
        "The human readable part should be: ",
      Bech32Exception.invalidProgramLength => 'The program length is invalid',
      Bech32Exception.invalidWitnessVersion =>
        'The witness version is invalid, it should be between 0 and 16.',
      Bech32Exception.invalidPadding => 'The padding is invalid',
    };
  }
}
