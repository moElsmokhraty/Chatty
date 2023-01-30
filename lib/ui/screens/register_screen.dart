import 'package:chat/helper/auth_helper.dart';
import 'package:chat/ui/widgets/snack_bar.dart';
import 'package:chat/ui/screens/login_screen.dart';
import 'package:chat/ui/widgets/custom_button.dart';
import 'package:chat/ui/widgets/custom_text_form_field.dart';
import 'package:chat/helper/validation_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;

  String? password;

  String? confirmPassword;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool obscure = true;

  bool confirmObsecure = true;

  Icon? icon = const Icon(Icons.visibility_outlined);

  Icon? confirmIcon = const Icon(Icons.visibility_outlined);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
                Image.asset(
                  'assets/images/scholar.png',
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
                      return validateEmail(value!);
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
                    return validatePassword(value!);
                  },
                  decoration: TextFormFieldStyle.textFormFieldStyle(
                    labelText: 'Confirm Password',
                    hintText: 'Enter Password Again',
                    icon: IconButton(onPressed: (){
                      if(confirmObsecure){
                        setState(() {
                          confirmObsecure = false;
                          confirmIcon = const Icon(Icons.visibility_off_outlined);
                        });
                      }else{
                        setState(() {
                          confirmObsecure = true;
                          confirmIcon = const Icon(Icons.visibility_outlined);
                        });
                      }
                    }, icon: confirmIcon!)
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                    text: 'Register',
                    function: () {
                      if (password != confirmPassword) {
                        showSnackBar(context,
                            'password and confirm password must be the same');
                      } else {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            registerToFireBaseAuth(email, password);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'email-already-in-use') {
                              showSnackBar(context,
                                  'The account already exists for that email.');
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                          showSnackBar(context, 'Account Created Successfully');
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        } else {
                          return;
                        }
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
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: const Text(
                        'Login!',
                        style: TextStyle(fontSize: 22, color: Colors.white),
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
  }
}
