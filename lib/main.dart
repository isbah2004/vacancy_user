import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vacancy_app/provider/auth_provider.dart';
import 'package:vacancy_app/provider/home_index_provider.dart';
import 'package:vacancy_app/provider/password_visibility_provider.dart';
import 'package:vacancy_app/screens/splashscreen/splash_screen.dart';
import 'package:vacancy_app/theme/theme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => VisibilityProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => HomeIndexProvider()),
    ],
    child: MaterialApp(title:'Vacancies',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: AppTheme.lightTheme,
    ),
  ));
}
