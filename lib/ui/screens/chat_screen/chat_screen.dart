import 'package:chat/cache_helper.dart';
import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/ui/widgets/custom_sent_chat_bubble.dart';
import 'package:chat/ui/screens/login_screen/login_screen.dart';
import 'package:chat/ui/widgets/custom_received_chat_bubble.dart';
import 'package:chat/ui/screens/chat_screen/chat_cubit/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static String routeName = 'chat';

  @override
  Widget build(BuildContext context) {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              email = null;
              CacheHelper.removeData(key: 'email');
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(Icons.logout),
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
              height: 50,
            ),
            const Text(
              'Chat',
              style: TextStyle(fontFamily: 'Pacifico'),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff2B475E),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return chatCubit.messagesList[index].id == email
                        ? SentChatBubble(message: chatCubit.messagesList[index].message)
                        : ReceivedChatBubble(message: chatCubit.messagesList[index].message);
                  },
                  controller: chatCubit.scrollController,
                  itemCount: chatCubit.messagesList.length,
                );
              },
            ),
          ),
          Container(
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
          )
        ],
      ),
    );
  }
}
