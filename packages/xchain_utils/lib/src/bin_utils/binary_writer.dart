import 'dart:ffi';
import 'dart:typed_data';

import 'package:xchain_utils/src/bin_utils/utf8_utils.dart';
import 'package:xchain_utils/src/bin_utils/varint.dart';

writeByte(int val, Uint8List buf, int pos) {
  buf[pos] = val & 255;
}

class Op<T> {
  /// Callback function to process the value.
  void Function(T val, Uint8List buff, @Uint32() int pos)? fn;

  /// Length of the operation in bytes.
  @Uint32()
  int len;

  /// Next operation in the chain.
  Op? next;

  /// Value to be processed by the operation.
  T val;

  Op({this.fn, required this.len, required this.val});

  void proceed(Uint8List buff, @Uint32() int pos) {
    if (fn != null) {
      fn!(val, buff, pos);
    }
  }
}

class BinaryWriter {
  @Uint32()
  int len = 0;
  Op head;
  Op tail;

  BinaryWriter()
      : head = Op(len: 0, val: 0),
        tail = Op(len: 0, val: 0) {
    head = Op(len: 0, val: 0);
    tail = head;
  }
  BinaryWriter _push<T>(
      void Function(T val, Uint8List buff, int pos) fn, int len, T val) {
    tail = tail.next = Op<T>(fn: fn, len: len, val: val);
    this.len += len;
    return this;
  }

  BinaryWriter uint32(int value) {
    len += (tail = tail.next = Op<int>(
            fn: writeVarint32,
            len: (value = value >>> 0) < 128
                ? 1
                : value < 16384
                    ? 2
                    : value < 2097152
                        ? 3
                        : value < 268435456
                            ? 4
                            : 5,
            val: value))
        .len;
    return this;
  }

  BinaryWriter int32(int value) {
    return value < 0
        ? _push<Varint64>(writeVarint64, 10, int64FromString(value.toString()))
        : uint32(value);
  }

  BinaryWriter string(String value) {
    var len = utf8Length(value);
    return len != 0
        ? uint32(len)._push(utf8Write, len, value)
        : _push(writeByte, this.len, 0);
  }

  static Uint8List alloc(int size) {
    return Uint8List(size);
  }

  BinaryWriter boolean(bool value) {
    return _push(writeByte, 1, value ? 1 : 0);
  }

  Uint8List finish() {
    var head = this.head.next, pos = 0;
    var buf = BinaryWriter.alloc(len);
    while (head != null) {
      head.proceed(buf, pos);
      pos += head.len;
      head = head.next;
    }
    return buf;
  }
}
