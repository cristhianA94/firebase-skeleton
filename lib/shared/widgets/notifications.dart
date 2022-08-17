import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notifications {
  static void goodNotification({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: "#50a22f",
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
      webPosition: "left",
      backgroundColor: Colors.greenAccent,
    );
  }

  static void badNotification({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: "#FF3100",
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
      webPosition: "left",
      backgroundColor: Colors.redAccent,
    );
  }
}
