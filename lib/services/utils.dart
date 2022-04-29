import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Utils {

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(BuildContext context, String message, Color? color){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color ??  Colors.deepOrange, duration: const Duration(seconds: 3)));
  }


  static bool validatePassword(String value) {
    return RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+-]).{8,30}$')
        .hasMatch(value);
  }

  static bool validateEmail(String email) {
    return RegExp(r'^([a-zA-z\d\.\-\_]+)@[a-z]+\.[a-z]+(\.[a-z]+)?$')
        .hasMatch(email);
  }
}