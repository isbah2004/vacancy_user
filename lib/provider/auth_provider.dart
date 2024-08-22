import 'package:flutter/material.dart';
import 'package:vacancy_app/screens/homescreen/home_screen.dart';
import 'package:vacancy_app/utils/constants.dart';
import 'package:vacancy_app/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void checkPassword(
      {required TextEditingController passwordController,
      required BuildContext context}) {
    setLoading(true);
    try {
      if (passwordController.text == Constants.loginPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        Utils.toastMessage(message: 'Please provide correct password', context: context);
      }
    } catch (e) {
      Utils.toastMessage(message: e.toString(), context: context);
    } finally {
      setLoading(false);
    }
  }
}
