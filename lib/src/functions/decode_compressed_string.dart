import 'dart:convert';

import 'package:archive/archive.dart';

String decompressServerDataWithGZip2(String compressedText) {
  final decoder = BZip2Decoder();
  final decompressedBytes = decoder.decodeBytes(base64Decode(compressedText));
  return utf8.decode(decompressedBytes);
}

String decompressStringWithGZip2(String compressedText) {
  final decoder = const GZipDecoder();
  final decompressedBytes = decoder.decodeBytes(base64Decode(compressedText));
  return utf8.decode(decompressedBytes);
}

String compressStringWithGZip2(String text) {
  final encoder = const GZipEncoder();
  final x = encoder.encode(utf8.encode(text));
  return base64.encode(x);
}
