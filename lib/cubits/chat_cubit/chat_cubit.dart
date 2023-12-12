import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chat/Models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<Message> messagesList = [];

  final ScrollController scrollController = ScrollController();

  TextEditingController messageController = TextEditingController();

  CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  void sendMessage({required String? message, required String? email}) {
    messagesRef.add({
      'message': message,
      'createdAt': DateTime.now(),
      'id': email,
    });
  }

  void getMessages() {
    messagesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messagesList));
    });
  }

  Future<void> setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    await fcm.subscribeToTopic('chat');
  }
}
