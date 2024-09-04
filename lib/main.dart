import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/screens/auth/login_screen.dart';
import 'package:todo/ui/screens/auth/register_screen.dart';
import 'package:todo/ui/screens/home/home.dart';
import 'package:todo/ui/utils/app_theme.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routes: {
        Home.routeName: (_) => const Home(),
        LoginScreen.routeName : (_) => const LoginScreen(),
        RegisterScreen.routeName : (_) => const RegisterScreen(),

      },
      initialRoute: LoginScreen.routeName,
    );
  }
}
