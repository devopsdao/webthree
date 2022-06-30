import 'dart:typed_data';

extension Web3Ext on ByteBuffer {
  void _safeRangeCheck(int listLength, int start, int length) {
    if (length < 0) {
      throw RangeError.value(length);
    }
    if (start < 0) {
      throw RangeError.value(start);
    }
    if (start + length < start || start + length > listLength) {
      throw RangeError.value(start + length);
    }
  }

  Uint8List safeAsUint8List([int offsetInBytes = 0, int? length]) {
    length ??= (lengthInBytes - offsetInBytes) ~/ Uint8List.bytesPerElement;
    _safeRangeCheck(
      lengthInBytes,
      offsetInBytes,
      length * Uint8List.bytesPerElement,
    );
    return asUint8List(offsetInBytes, length);
  }
}

Uint8List uint8ListFromList(List<int> data) {
  if (data is Uint8List) return data;

  return Uint8List.fromList(data);
}

Uint8List padUint8ListTo32(Uint8List data) {
  assert(data.length <= 32);
  if (data.length == 32) return data;

  // todo there must be a faster way to do this?
  return Uint8List(32)..setRange(32 - data.length, 32, data);
}
