import 'package:chat/ui/screens/chat_screen/chat_cubit/chat_cubit.dart';
import 'package:chat/ui/widgets/custom_received_chat_bubble.dart';
import 'package:chat/ui/widgets/custom_sent_chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  static String routeName = 'chat';

  final ScrollController controller = ScrollController();

  TextEditingController messageController = TextEditingController();

  CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
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
                      return BlocProvider.of<ChatCubit>(context)
                                  .messagesList[index]
                                  .id ==
                              email
                          ? SentChatBubble(
                              message: BlocProvider.of<ChatCubit>(context)
                                  .messagesList[index]
                                  .message)
                          : ReceivedChatBubble(
                              message: BlocProvider.of<ChatCubit>(context)
                                  .messagesList[index]
                                  .message);
                    },
                    controller: controller,
                    itemCount:
                        BlocProvider.of<ChatCubit>(context).messagesList.length,
                  );
                },
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(4),
                child: TextField(
                  controller: messageController,
                  onSubmitted: (message) {
                    if (message.isNotEmpty && message.trim().isNotEmpty) {
                      BlocProvider.of<ChatCubit>(context)
                          .sendMessage(message: message, email: email);
                      messageController.clear();
                      controller.animateTo(controller.position.minScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn);
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
                            if (messageController.text.isNotEmpty &&
                                messageController.text.trim().isNotEmpty) {
                              BlocProvider.of<ChatCubit>(context).sendMessage(
                                  message: messageController.text,
                                  email: email);
                              messageController.clear();
                              FocusScope.of(context).unfocus();
                              controller.animateTo(
                                  controller.position.minScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn);
                            }
                          }),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xff2B475E),
                        ),
                      )),
                ))
          ],
        ));
  }
}
