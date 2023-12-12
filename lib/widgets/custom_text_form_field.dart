import 'package:flutter/material.dart';

class TextFormFieldStyle {
  static InputDecoration textFormFieldStyle(
      {String? labelText, String? hintText, Widget? icon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(12),
      labelText: labelText,
      suffixIcon: icon,
      labelStyle: const TextStyle(
          color: Colors.white
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
          color: Colors.white
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white
          )
      ),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white
          )
      ),
    );
  }
}