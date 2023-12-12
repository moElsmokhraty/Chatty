import 'firebase_options.dart';
import 'utils/bloc_observer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/constants.dart';
import 'package:chat/utils/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat/views/chat_view/chat_view.dart';
import 'package:chat/views/login_view/login_view.dart';
import 'package:chat/views/register_view/register_view.dart';
import 'package:chat/views/chat_view/widgets/chat_view_body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(<Future>[
    CacheHelper.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  email = await CacheHelper.getData(key: 'email');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  Bloc.observer = MyBlocObserver();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: email == null ? const LoginView() : const ChatViewBody(),
      initialRoute: email == null ? LoginView.routeName : ChatViewBody.routeName,
      routes: {
        LoginView.routeName: (_) => const LoginView(),
        RegisterView.routeName: (_) => const RegisterView(),
        ChatView.routeName: (_) => const ChatView()
      },
    );
  }
}
