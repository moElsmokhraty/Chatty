import 'package:chat/ui/screens/chat_screen.dart';
import 'package:chat/ui/screens/login_screen.dart';
import 'package:chat/ui/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RegisterScreen.routeName,
      routes: {
        LoginScreen.routeName: (_)=> const LoginScreen(),
        RegisterScreen.routeName: (_)=> const RegisterScreen(),
        ChatScreen.routeName: (_)=> ChatScreen()
      },
    );
  }
}
