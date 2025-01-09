import 'dart:convert';

import 'package:archive/archive.dart';

String decompressStringWithGZip2(String compressedText) {
  final decoder = BZip2Decoder();
  final decompressedBytes = decoder.decodeBytes(base64Decode(compressedText));
  return utf8.decode(decompressedBytes);
}
