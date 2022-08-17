import 'package:firebase_skeleton/src/pages/firebase_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_skeleton/firebase_options.dart';

import 'package:firebase_skeleton/src/pages/datil_invoice.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
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
      restorationScopeId: 'app',
      initialRoute: '/firebase_stream',
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case DatilInvoicePage.routeName:
                return DatilInvoicePage();
              case FirebaseDataPage.routeName:
                return FirebaseDataPage();
              default:
                return FirebaseDataPage();
              // : const OptConsentScreen();
            }
          },
        );
      },
    );
  }
}


/* 
Navigator.restorablePushNamed(
  context,
  ShortLifeSignatureScreen.routeName,
);
 */