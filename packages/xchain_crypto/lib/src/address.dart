/// Address utilities for converting public keys to raw addresses and Bech32 addresses.
/// This library provides functions to convert Ed25519 public keys to raw addresses
/// and to convert public keys to Bech32 addresses.
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:xchain_crypto/xchain_crypto.dart';

/// Converts a raw Ed25519 public key to a raw address.
///
/// [pubkeyData] is the raw public key as a [Uint8List].
/// Returns a [Uint8List] containing the raw address.
Uint8List rawEd25519PubkeyToRawAddress(Uint8List pubkeyData) {
  if (pubkeyData.length != 32) {
    throw ArgumentError('Invalid Ed25519 pubkey length: ${pubkeyData.length}');
  }

  final digest = sha256.convert(pubkeyData);
  return Uint8List.fromList(
      digest.bytes.sublist(0, 20)); // Take the first 20 bytes
}

/// Converts a public key in base64 format to a raw address.
///
/// [pubkey] is the base64-encoded public key string.
/// Returns a [Uint8List] containing the raw address.
Uint8List pubKeytoRawAddress(String pubkey) {
  final pubkeyData = base64Decode(pubkey);
  return rawEd25519PubkeyToRawAddress(pubkeyData);
}

/// Converts a public key in base64 format to an address string using bech32.
///
/// [prefix] is the human-readable part of the Bech32 address.
/// [pubkey] is the base64-encoded public key string.
/// Returns a Bech32 address string.
String pubKeyToAddress(String pubkey, String prefix) {
  final rawAddress = pubKeytoRawAddress(pubkey);
  return toBech32(prefix, rawAddress);
}
