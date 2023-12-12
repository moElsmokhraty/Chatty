part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<Message> messages;

  ChatSuccess(this.messages);
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);
}
