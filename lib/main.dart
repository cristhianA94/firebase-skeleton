import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_skeleton/firebase_options.dart';

import 'package:firebase_skeleton/src/pages/datil_invoice.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      title: 'Firebase Skeleton',
      home: Scaffold(
        body: DatilInvoicePage(),
      ),
    );
  }
}
