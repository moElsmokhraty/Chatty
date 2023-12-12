import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_text_field.dart';
import 'package:chat/utils/constants.dart';
import '../../../cubits/chat_cubit/chat_cubit.dart';
import '../../../widgets/custom_sent_chat_bubble.dart';
import '../../../widgets/custom_received_chat_bubble.dart';

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({super.key});

  static String routeName = 'chat';

  @override
  Widget build(BuildContext context) {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state is ChatSuccess) {
                return ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return chatCubit.messagesList[index].id == email
                        ? SentChatBubble(
                            message: chatCubit.messagesList[index].message)
                        : ReceivedChatBubble(
                            message: chatCubit.messagesList[index].message);
                  },
                  controller: chatCubit.scrollController,
                  itemCount: chatCubit.messagesList.length,
                );
              } else if (state is ChatError) {
                return Center(
                  child: Text(state.error),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xff2B475E)));
              }
            },
          ),
        ),
        ChatTextField(chatCubit: chatCubit),
      ],
    );
  }
}
