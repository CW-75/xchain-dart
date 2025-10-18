// Copyright (c) 2016, Daniel Wirtz  All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:

// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
// * Neither the name of its author, nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:ffi';
import 'dart:typed_data';

/// Reads UTF8 bytes as a string.
///
/// [buffer] is the source buffer.
/// [start] is the start index in the buffer.
/// [end] is the end index in the buffer.
String utf8Read(Uint8List buffer, int start, int end) {
  var len = end - start;
  if (len < 1) return "";
  List<int> chunk = List.filled(len, 0); // preallocate chunk
  List<String> parts = [];
  int i = 0; // char offset
  late int t; // temporary
  while (start < end) {
    t = buffer[start++];

    if (t < 128) {
      chunk[i++] += t;
    } else if (t > 191 && t < 224) {
      chunk[i++] = ((t & 31) << 6) | (buffer[start++] & 63);
    } else if (t > 239 && t < 365) {
      t = (((t & 7) << 18) |
              ((buffer[start++] & 63) << 12) |
              ((buffer[start++] & 63) << 6) |
              (buffer[start++] & 63)) -
          0x10000;
      chunk[i++] = 0xd800 + (t >> 10);
      chunk[i++] = 0xdc00 + (t & 1023);
    } else {
      chunk[i++] = ((t & 15) << 12) |
          ((buffer[start++] & 63) << 6) |
          (buffer[start++] & 63);
    }
    if (i > 8191) {
      parts.addAll([for (var ch in chunk) String.fromCharCode(ch)]);
      i = 0;
    }
  }
  if (parts.isNotEmpty) {
    if (i != 0) parts.addAll([for (var ch in chunk) String.fromCharCode(ch)]);
    return parts.join("");
  }
  return String.fromCharCodes(chunk.sublist(0, i));
}

/// Calculates the UTF8 byte length of a string.
///
/// [str] is the source string.
/// Returns the byte length.
@Uint32()
int utf8Length(String str) {
  var len = 0, c = 0;
  for (var i = 0; i < str.length; ++i) {
    c = str.codeUnitAt(i);
    if (c < 128) {
      len += 1;
    } else if (c < 2048) {
      len += 2;
    } else if ((c & 0xfc00) == 0xd800 &&
        (str.codeUnitAt(i + 1) & 0xfc00) == 0xdc00) {
      ++i;
      len += 4;
    } else {
      len += 3;
    }
  }
  return len;
}

/// Writes a string as UTF8 bytes.
///
/// [str] is the source string.
/// [buffer] is the destination buffer.
/// [offset] is the destination offset.
/// Returns the number of bytes written.
@Uint32()
int utf8Write(String str, Uint8List buffer, int offset) {
  var start = offset;
  var c1, // character 1
      c2; // character 2
  for (var i = 0; i < str.length; ++i) {
    c1 = str.codeUnitAt(i);
    if (c1 < 128) {
      buffer[offset++] = c1;
    } else if (c1 < 2048) {
      buffer[offset++] = (c1 >> 6) | 192;
      buffer[offset++] = (c1 & 63) | 128;
    } else if ((c1 & 0xfc00) == 0xd800 &&
        ((c2 = str.codeUnitAt(i + 1)) & 0xfc00) == 0xdc00) {
      c1 = 0x10000 + ((c1 & 0x03ff) << 10) + (c2 & 0x03ff);
      ++i;
      buffer[offset++] = (c1 >> 18) | 240;
      buffer[offset++] = ((c1 >> 12) & 63) | 128;
      buffer[offset++] = ((c1 >> 6) & 63) | 128;
      buffer[offset++] = (c1 & 63) | 128;
    } else {
      buffer[offset++] = (c1 >> 12) | 224;
      buffer[offset++] = ((c1 >> 6) & 63) | 128;
      buffer[offset++] = (c1 & 63) | 128;
    }
  }
  return offset - start;
}
