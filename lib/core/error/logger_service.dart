import 'package:flutter/material.dart';

class LoggerService {
  static void log(String tag, String message, [StackTrace? st]) {
    debugPrint("[$tag] $message");
    if (st != null) debugPrint(st.toString());
  }

  static void info(String tag, String message) {
    debugPrint("[INFO][$tag] $message");
  }

  static void error(String tag, String message, [StackTrace? st]) {
    debugPrint("[ERROR][$tag] $message");
    if (st != null) debugPrint(st.toString());
  }
}
