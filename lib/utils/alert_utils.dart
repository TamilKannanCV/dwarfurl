import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AlertUtils {
  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
