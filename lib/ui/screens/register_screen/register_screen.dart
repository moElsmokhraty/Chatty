import 'package:chat/ui/screens/register_screen/register_cubit/register_cubit.dart';
import 'package:chat/ui/widgets/snack_bar.dart';
import 'package:chat/ui/screens/login_screen/login_screen.dart';
import 'package:chat/ui/widgets/custom_button.dart';
import 'package:chat/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  static String routeName = 'register';

  String? email, password, confirmPassword;

  final formKey = GlobalKey<FormState>();

  bool obscure = true;

  bool confirmObsecure = true;

  Icon? icon = const Icon(Icons.visibility_outlined);

  Icon? confirmIcon = const Icon(Icons.visibility_outlined);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          context.loaderOverlay.show();
        } else if (state is RegisterSuccess) {
          context.loaderOverlay.hide();
          showSnackBar(context, 'Account Created Successfully');
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else if (state is RegisterFailure) {
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
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Text(
                        'Register',
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
                        return BlocProvider.of<RegisterCubit>(context)
                            .validateEmail(value!);
                      },
                      decoration: TextFormFieldStyle.textFormFieldStyle(
                          labelText: 'Email', hintText: 'Enter Email')),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: obscure,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      return BlocProvider.of<RegisterCubit>(context)
                          .validatePassword(value!);
                    },
                    decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        icon: IconButton(
                            onPressed: () {
                              // if(obscure){
                              //   setState(() {
                              //     obscure = false;
                              //     icon = const Icon(Icons.visibility_off_outlined);
                              //   });
                              // }else{
                              //   setState(() {
                              //     obscure = true;
                              //     icon = const Icon(Icons.visibility_outlined);
                              //   });
                              // }
                            },
                            icon: icon!)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: confirmObsecure,
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    validator: (value) {
                      return BlocProvider.of<RegisterCubit>(context)
                          .validatePassword(value!);
                    },
                    decoration: TextFormFieldStyle.textFormFieldStyle(
                        labelText: 'Confirm Password',
                        hintText: 'Enter Password Again',
                        icon: IconButton(
                            onPressed: () {
                              // if(confirmObsecure){
                              //   setState(() {
                              //     confirmObsecure = false;
                              //     confirmIcon = const Icon(Icons.visibility_off_outlined);
                              //   });
                              // }else{
                              //   setState(() {
                              //     confirmObsecure = true;
                              //     confirmIcon = const Icon(Icons.visibility_outlined);
                              //   });
                              // }
                            },
                            icon: confirmIcon!)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                      text: 'Register',
                      function: () {
                        if (formKey.currentState!.validate()) {
                          if (password != confirmPassword) {
                            showSnackBar(context,
                                'password and confirm password must be the same');
                          } else {
                            BlocProvider.of<RegisterCubit>(context)
                                .registerToFireBaseAuth(
                                email: email!, password: password!);
                          }
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
      ),
    );
  }
}
