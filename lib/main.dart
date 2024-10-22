// ignore_for_file: prefer_const_constructors

import 'package:antarkanma/pages/Home/main_page.dart';
import 'package:antarkanma/pages/sign_in_page.dart';
import 'package:antarkanma/pages/sign_up_page.dart';
import 'package:antarkanma/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugDefaultTargetPlatformOverride =
        TargetPlatform.android; // atau TargetPlatform.iOS
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AnatarkanMa',
      routes: {
        '/': (context) => const SplashPage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => MainPage(),
      },
    );
  }
}
