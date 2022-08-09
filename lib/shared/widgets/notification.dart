import 'package:flutter/material.dart';

class Notifications {
  static SnackBar customSnackBarGood({required String content}) {
    return SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, letterSpacing: 0.5),
      ),
    );
  }

  static SnackBar customSnackBarWrong({required String content}) {
    return SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
      ),
    );
  }
}
