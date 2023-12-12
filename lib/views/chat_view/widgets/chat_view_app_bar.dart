import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/cache_helper.dart';
import '../../login_view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            email = null;
            CacheHelper.removeData(key: 'email');
            Navigator.pushReplacementNamed(context, LoginView.routeName);
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        )
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/splash.png',
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
