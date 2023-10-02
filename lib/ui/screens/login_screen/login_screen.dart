import 'package:chat/cache_helper.dart';
import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/ui/widgets/snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/ui/widgets/custom_button.dart';
import 'package:chat/ui/widgets/custom_text_form_field.dart';
import 'package:chat/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat/ui/screens/register_screen/register_screen.dart';
import 'package:chat/ui/screens/chat_screen/chat_cubit/chat_cubit.dart';
import 'package:chat/ui/screens/login_screen/login_cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    final height = MediaQuery.sizeOf(context).height;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          showSnackBar(context, 'Logged In Successfully');
          email = state.user!.email;
          CacheHelper.setData(key: 'email', value: state.user!.email);
          chatCubit.getMessages();
          Navigator.pushReplacementNamed(context, ChatScreen.routeName);
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xff2B475E),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: loginCubit.formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.2),
                    Image.asset('assets/images/splash.png', height: 100),
                    const Text(
                      'Scholar Chat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: loginCubit.emailController,
                      validator: (value) {
                        return loginCubit.validateEmail(value!);
                      },
                      decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Email',
                        hintText: 'Enter Email',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: loginCubit.passwordController,
                      validator: (value) {
                        return loginCubit.validatePassword(value!);
                      },
                      decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        icon: IconButton(
                          onPressed: () {
                            loginCubit.changeObscure();
                          },
                          icon: loginCubit.icon,
                        ),
                      ),
                      obscureText: loginCubit.obscure,
                    ),
                    const SizedBox(height: 15),
                    state is LoginLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'Login',
                            function: () {
                              if (loginCubit.formKey.currentState!.validate()) {
                                loginCubit.logInFireBaseAuth(
                                  email: loginCubit.emailController.text,
                                  password: loginCubit.passwordController.text,
                                );
                              } else {
                                return;
                              }
                            },
                          ),
                    const SizedBox(height: 15),
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
        );
      },
    );
  }
}
