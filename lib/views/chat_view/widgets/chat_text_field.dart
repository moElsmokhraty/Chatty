import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'package:chat/cubits/chat_cubit/chat_cubit.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({super.key, required this.chatCubit});

  final ChatCubit chatCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      child: TextField(
        controller: chatCubit.messageController,
        onSubmitted: (message) {
          if (message.isNotEmpty && message.trim().isNotEmpty) {
            chatCubit.sendMessage(message: message, email: email);
            chatCubit.messageController.clear();
            chatCubit.scrollController.animateTo(
              chatCubit.scrollController.position.minScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          } else {
            return;
          }
        },
        decoration: InputDecoration(
          hintText: 'Send Message',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send_outlined),
            color: const Color(0xff2B475E),
            onPressed: () {
              if (chatCubit.messageController.text.isNotEmpty &&
                  chatCubit.messageController.text.trim().isNotEmpty) {
                chatCubit.sendMessage(
                  message: chatCubit.messageController.text,
                  email: email,
                );
                chatCubit.messageController.clear();
                FocusScope.of(context).unfocus();
                chatCubit.scrollController.animateTo(
                  chatCubit.scrollController.position.minScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              }
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xff2B475E),
            ),
          ),
        ),
      ),
    );
  }
}
