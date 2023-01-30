import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.text,this.function,Key? key}) : super(key: key);

   late String? text;

   late VoidCallback? function;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(text!, style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }
}
