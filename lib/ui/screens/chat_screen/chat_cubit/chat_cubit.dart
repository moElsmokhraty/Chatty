import 'package:bloc/bloc.dart';
import 'package:chat/Models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<Message> messagesList = [];

  CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  void sendMessage({required String? message, required String? email}) {
    messagesRef
        .add({'message': message, 'createdAt': DateTime.now(), 'id': email});
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
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
