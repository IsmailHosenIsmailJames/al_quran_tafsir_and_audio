import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showTwoestedMessage(String message, ToastificationType? type) {
  toastification.show(
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
    alignment: const Alignment(1, 0.8),
    type: type,
  );
}
