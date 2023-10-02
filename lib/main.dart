import 'package:chat/cache_helper.dart';
import 'package:chat/constants.dart';

import 'bloc_observer.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat/ui/screens/login_screen/login_screen.dart';
import 'package:chat/ui/screens/register_screen/register_screen.dart';
import 'package:chat/ui/screens/chat_screen/chat_cubit/chat_cubit.dart';
import 'package:chat/ui/screens/login_screen/login_cubit/login_cubit.dart';
import 'package:chat/ui/screens/register_screen/register_cubit/register_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  email = CacheHelper.getData(key: 'email');
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: email == null ? const LoginScreen() : const ChatScreen(),
        initialRoute: email == null ? LoginScreen.routeName : ChatScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          ChatScreen.routeName: (_) => const ChatScreen()
        },
      ),
    );
  }
}
