import 'package:chat/ui/screens/chat_screen/chat_cubit/chat_cubit.dart';
import 'package:chat/ui/screens/login_screen/login_cubit/login_cubit.dart';
import 'package:chat/ui/widgets/snack_bar.dart';
import 'package:chat/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat/ui/screens/register_screen/register_screen.dart';
import 'package:chat/ui/widgets/custom_button.dart';
import 'package:chat/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  static String routeName = 'login';

  String? email, password;

  final formKey = GlobalKey<FormState>();

  bool obscure = true;

  Icon? icon = const Icon(Icons.visibility_outlined);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          context.loaderOverlay.show();
        } else if (state is LoginSuccess) {
          context.loaderOverlay.hide();
          showSnackBar(context, 'Logged In Successfully');
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushReplacementNamed(context, ChatScreen.routeName,
              arguments: state.user!.email);
        } else if (state is LoginFailure) {
          context.loaderOverlay.hide();
          showSnackBar(context, state.errMessage!);
        }
      },
      child: LoaderOverlay(
        child: Scaffold(
          backgroundColor: const Color(0xff2B475E),
          body: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset('assets/images/splash.png', height: 100),
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
                      return BlocProvider.of<LoginCubit>(context)
                          .validateEmail(value!);
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
                      return BlocProvider.of<LoginCubit>(context)
                          .validatePassword(value!);
                    },
                    decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        icon: IconButton(
                            onPressed: () {
                              if (obscure) {
                                // setState(() {
                                //   obscure = false;
                                //   icon = const Icon(Icons.visibility_off_outlined);
                                // });
                              } else {
                                // setState(() {
                                //   obscure = true;
                                //   icon = const Icon(Icons.visibility_outlined);
                                // });
                              }
                            },
                            icon: icon!)),
                    obscureText: obscure,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                      text: 'Login',
                      function: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<LoginCubit>(context)
                              .logInFireBaseAuth(
                                  email: email!, password: password!);
                        } else {
                          return;
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: const Text(
                          'Create one!',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
