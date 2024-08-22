import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vacancy_app/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:vacancy_app/screens/authscreen/login_screen.dart';
import 'package:vacancy_app/utils/constants.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 2,
              child: Image(
                image: AssetImage(Constants.mnv),
              ),
            ),
            Expanded(
              flex: 2,
              child: Image(
                image: AssetImage(Constants.logo),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MulticolorProgressIndicator(),
            Expanded(flex: 1, child: SizedBox())
          ],
        ),
      ),
    );
  }
}
