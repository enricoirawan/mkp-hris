import 'package:flutter/material.dart';
import 'package:mkp_hris/utils/theme.dart';

class CustomSnackbar {
  CustomSnackbar._();
  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kRedColor,
      ),
    );
  }

  static buildSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kGreenColor,
      ),
    );
  }

  static buildInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
