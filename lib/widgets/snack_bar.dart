import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, textAlign: TextAlign.center),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
