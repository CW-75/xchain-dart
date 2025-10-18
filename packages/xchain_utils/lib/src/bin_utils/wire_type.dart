enum WireType {
  varint,
  fixed64,
  lengthDelimited,
  fixed32,
}

extension WireTypeExt on WireType {
  int get value {
    switch (this) {
      case WireType.varint:
        return 0;
      case WireType.fixed64:
        return 1;
      case WireType.lengthDelimited:
        return 2;
      case WireType.fixed32:
        return 5;
    }
  }
}
