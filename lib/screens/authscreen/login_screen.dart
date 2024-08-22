import 'package:flutter/material.dart';
import 'package:vacancy_app/provider/auth_provider.dart';
import 'package:vacancy_app/provider/password_visibility_provider.dart';
import 'package:vacancy_app/reusablewidgets/reusable_button.dart';
import 'package:vacancy_app/reusablewidgets/reusable_text_field.dart';
import 'package:vacancy_app/utils/constants.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            const Expanded(
              flex: 4,
              child: Image(
                image: AssetImage(Constants.logo),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Consumer2<VisibilityProvider, AuthProvider>(
                builder: (BuildContext context, VisibilityProvider value1,
                    AuthProvider value2, Widget? child) {
                  return ReusableTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: value1.visibility,
                    prefix: const Icon(Icons.lock),
                    suffix: GestureDetector(
                      onTap: () {
                        value1.setVisibility();
                      },
                      child: Icon(value1.visibility
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                    ),
                    onFieldSubmitted: (value) {
                      value2.checkPassword(
                          passwordController: passwordController,
                          context: context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Consumer<AuthProvider>(
                builder:
                    (BuildContext context, AuthProvider value, Widget? child) {
                  return ReusableButton(
                      title: Constants.login,
                      onTap: () {
                        value.checkPassword(
                            passwordController: passwordController,
                            context: context);
                      },
                      loading: value.loading);
                },
              ),
            ),
            const Expanded(flex: 3, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
