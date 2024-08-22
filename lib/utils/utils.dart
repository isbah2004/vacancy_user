import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vacancy_app/theme/theme.dart';

class Utils {
  static Future urlLauncher(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static void changeFocus(
      {required FocusNode currentFocus,
      required FocusNode nextFocus,
      required BuildContext context}) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static void toastMessage(
      {required String message, required BuildContext context}) {
    Flushbar(
      title: " ",
     
      backgroundColor: AppTheme.greyColor,messageText: Text(message,style: GoogleFonts.kanit(color: AppTheme.darkGrey,fontWeight: FontWeight.bold,),),
      messageSize: 15,
      titleSize: 0,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
