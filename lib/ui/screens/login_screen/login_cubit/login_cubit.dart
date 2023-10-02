import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final formKey = GlobalKey<FormState>();

  bool obscure = true;

  Icon icon = const Icon(Icons.visibility_outlined);

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Future<void> logInFireBaseAuth({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    if (await InternetConnectionChecker().hasConnection) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(LoginSuccess(user: FirebaseAuth.instance.currentUser));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(LoginFailure(errMessage: 'No User Registered With Email'));
        } else if (e.code == 'wrong-password') {
          emit(LoginFailure(errMessage: 'Wrong Password Provided'));
        }
      } catch (e) {
        emit(LoginFailure(errMessage: 'Something Went Wrong'));
      }
    } else {
      emit(LoginFailure(errMessage: 'No Internet Connection'));
    }
  }

  String? validateEmail(String value) {
    RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter email';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid email';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(String value) {
    RegExp regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void changeObscure() {
    obscure = !obscure;
    if (obscure) {
      icon = const Icon(Icons.visibility_outlined);
    } else {
      icon = const Icon(Icons.visibility_off_outlined);
    }
    emit(ChangeObscure());
  }
}
