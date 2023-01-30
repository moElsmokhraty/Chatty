import 'package:chat/Models/message.dart';
import 'package:chat/ui/widgets/custom_received_chat_bubble.dart';
import 'package:chat/ui/widgets/custom_sent_chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  static String routeName = 'chat';

  final ScrollController controller = ScrollController();

  TextEditingController messageController = TextEditingController();

  CollectionReference messagesRef = FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messagesRef.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/scholar.png',
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
                    child: ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                      return snapshot.data!.docs[index].id == email ? SentChatBubble(message: Message.fromJson(snapshot.data!.docs[index]).message)
                          : SentChatBubble(message: Message.fromJson(snapshot.data!.docs[index]).message);
                    },
                      controller: controller,
                      itemCount: snapshot.data!.docs.length,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(4),
                      child: TextField(
                        controller: messageController,
                        onSubmitted: (data) {
                          messagesRef.add({
                            'message': data,
                            'createdAt': DateTime.now(),
                            'id': email
                          });
                          messageController.clear();
                          controller.animateTo(
                              controller.position.minScrollExtent,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn
                          );
                        },
                        decoration: InputDecoration(
                            hintText: 'Send Message',
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.send_outlined),
                                color: const Color(0xff2B475E),
                                onPressed: () {
                                  messagesRef.add({
                                    'message': messageController.text,
                                    'createdAt': DateTime.now()
                                  });
                                  messageController.clear();
                                  FocusScope.of(context).unfocus();
                                  controller.animateTo(
                                      controller.position.minScrollExtent,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn
                                  );
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
        } else {
          return Row(
            children: const [
              Spacer(),
              CircularProgressIndicator(),
              Spacer()
            ],
          );
        }
      },
    );
  }
}