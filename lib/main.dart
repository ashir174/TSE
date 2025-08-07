import 'package:flutter/material.dart';
import 'package:tse/ManualModeScreen.dart';
import 'package:tse/TimerSettingsScreen.dart';
import 'splash_screen.dart';
import 'LoginScreen.dart';
import 'signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TSE App',
      theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),


      },

      // home: ManualModeScreen(),
    );
  }
}
