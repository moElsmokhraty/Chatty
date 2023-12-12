import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/chat_cubit/chat_cubit.dart';
import 'package:chat/views/chat_view/widgets/chat_view_body.dart';
import 'package:chat/views/chat_view/widgets/chat_view_app_bar.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  static const String routeName = 'chat';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit()
        ..setupPushNotifications()
        ..getMessages(),
      child: const Scaffold(
        appBar: ChatViewAppBar(),
        body: ChatViewBody(),
      ),
    );
  }
}
