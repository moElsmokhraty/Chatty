import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/ui/widgets/snack_bar.dart';
import 'package:chat/ui/widgets/custom_button.dart';
import 'package:chat/ui/widgets/custom_text_form_field.dart';
import 'package:chat/ui/screens/login_screen/login_screen.dart';
import 'package:chat/ui/screens/register_screen/register_cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String routeName = 'register';

  @override
  Widget build(BuildContext context) {
    final registerCubit = BlocProvider.of<RegisterCubit>(context);
    final height = MediaQuery.sizeOf(context).height;
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          showSnackBar(context, 'Account Created Successfully');
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else if (state is RegisterFailure) {
          showSnackBar(context, state.errMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xff2B475E),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: registerCubit.formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.15),
                    Image.asset(
                      'assets/images/splash.png',
                      height: 100,
                    ),
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
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: registerCubit.emailController,
                      validator: (value) {
                        return registerCubit.validateEmail(value!);
                      },
                      decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Email',
                        hintText: 'Enter Email',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: registerCubit.passwordController,
                      obscureText: registerCubit.obscure,
                      validator: (value) {
                        return registerCubit.validatePassword(value!);
                      },
                      decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        icon: IconButton(
                          onPressed: () {
                            registerCubit.changeObsecure();
                          },
                          icon: registerCubit.icon,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: registerCubit.confirmPasswordController,
                      obscureText: registerCubit.confirmObsecure,
                      validator: (value) {
                        return registerCubit.validatePassword(value!);
                      },
                      decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Confirm Password',
                        hintText: 'Enter Password Again',
                        icon: IconButton(
                          onPressed: () {
                            registerCubit.changeConfirmObsecure();
                          },
                          icon: registerCubit.confirmIcon,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    state is RegisterLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'Register',
                            function: () {
                              if (registerCubit.formKey.currentState!
                                  .validate()) {
                                if (registerCubit.passwordController.text !=
                                    registerCubit
                                        .confirmPasswordController.text) {
                                  showSnackBar(
                                    context,
                                    'password and confirm password must be the same',
                                  );
                                } else {
                                  registerCubit.registerToFireBaseAuth(
                                    email: registerCubit.emailController.text,
                                    password:
                                        registerCubit.passwordController.text,
                                  );
                                }
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
                          'Already have account? ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.routeName);
                          },
                          child: const Text(
                            'Login!',
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
