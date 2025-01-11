import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'safe_substring.dart';

String encodeEmailForId(String email, {int? len}) {
  return safeSubString(md5.convert(utf8.encode(email)).toString(), len ?? 36);
}
