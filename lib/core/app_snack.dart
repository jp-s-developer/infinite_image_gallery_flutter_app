import 'package:flutter/material.dart';

import '../main.dart';

class AppSnackBar {
  static void show(String message) {
    final messenger = rootScaffoldMessengerKey.currentState;

    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  static void success(String message) {
    show(message);
  }

  static void error(String message) {
    final messenger = rootScaffoldMessengerKey.currentState;

    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
  }
}