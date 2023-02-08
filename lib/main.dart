import 'package:chat/ui/screens/chat_screen/chat_cubit/chat_cubit.dart';
import 'package:chat/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat/ui/screens/login_screen/login_cubit/login_cubit.dart';
import 'package:chat/ui/screens/login_screen/login_screen.dart';
import 'package:chat/ui/screens/register_screen/register_cubit/register_cubit.dart';
import 'package:chat/ui/screens/register_screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BlocObserver.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> LoginCubit()),
        BlocProvider(create: (context)=> RegisterCubit()),
        BlocProvider(create: (context)=> ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_)=> LoginScreen(),
          RegisterScreen.routeName: (_)=> RegisterScreen(),
          ChatScreen.routeName: (_)=> ChatScreen()
        },
      ),
    );
  }
}
