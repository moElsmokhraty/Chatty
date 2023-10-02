import 'package:flutter/material.dart';

class ReceivedChatBubble extends StatelessWidget {
  const ReceivedChatBubble({this.message, Key? key}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.only(bottom: 24, right: 24, top: 24, left: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          color: Color(0xff2B475E),
        ),
        child: Text(message!, style: const TextStyle(
            color: Colors.white
        ),),
      ),
    );
  }
}
