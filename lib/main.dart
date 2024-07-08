import 'package:breeze_mobile/app/routes.dart';
import 'package:breeze_mobile/app/service_locator.dart';
import 'package:breeze_mobile/firebase_options.dart';
import 'package:breeze_mobile/models/restaurant.dart';
import 'package:breeze_mobile/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeServiceLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      // home: const OrderMainPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      onGenerateRoute: Routes.createRoutes,
    );
  }
}
