import 'package:flutter/material.dart';

class LoggerService {
  static void log(String tag, String message, [StackTrace? st]) {
    debugPrint("[$tag] $message");
    if (st != null) debugPrint(st.toString());

    // Remote logging
    // Sentry.captureMessage(message);
  }

  static void error(String tag, String message, [StackTrace? st]) {
    debugPrint("[ERROR][$tag] $message");
    if (st != null) debugPrint(st.toString());
    // Remote logging
    // Sentry.captureException(Exception(message), stackTrace: st);
  }
}
