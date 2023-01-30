import 'package:chat/helper/auth_helper.dart';
import 'package:chat/ui/widgets/snack_bar.dart';
import 'package:chat/ui/screens/chat_screen.dart';
import 'package:chat/ui/screens/register_screen.dart';
import 'package:chat/ui/widgets/custom_button.dart';
import 'package:chat/ui/widgets/custom_text_form_field.dart';
import 'package:chat/helper/validation_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;

  String? password;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool obscure = true;

  Icon? icon = const Icon(Icons.visibility_outlined);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2B475E),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset('assets/images/scholar.png', height: 100),
              const Text(
                'Scholar Chat',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: const [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  email = value;
                },
                validator: (value) {
                  return validateEmail(value!);
                },
                decoration: TextFormFieldStyle.textFormFieldStyle(
                    labelText: 'Email', hintText: 'Enter Email'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  password = value;
                },
                validator: (value) {
                  return validatePassword(value!);
                },
                decoration: TextFormFieldStyle.textFormFieldStyle(
                  labelText: 'Password', hintText: 'Enter Password',
                  icon: IconButton(onPressed: (){
                    if(obscure){
                      setState(() {
                        obscure = false;
                        icon = const Icon(Icons.visibility_off_outlined);
                      });
                    }else{
                      setState(() {
                        obscure = true;
                        icon = const Icon(Icons.visibility_outlined);
                      });
                    }
                  }, icon: icon!)
                ),
                obscureText: obscure,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                  text: 'Login',
                  function: () async{
                    if(await checkConnection() == true) {
                      if (formKey.currentState!.validate()) {
                        try {
                          logInFireBaseAuth(email, password);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(
                                context, 'No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(context,
                                'Wrong password provided for that user.');
                          }
                        }
                        showSnackBar(context, 'Logged In Successfully');
                        Navigator.pushReplacementNamed(context, ChatScreen.routeName, arguments: email);
                      } else {
                        return;
                      }
                    } else {
                      showSnackBar(context, 'No Internet Connection');
                    }
                  }),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don`t have account? ',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, RegisterScreen.routeName);
                    },
                    child: const Text(
                      'Create one!',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }
}
