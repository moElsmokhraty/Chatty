import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void registerToFireBaseAuth({required String? email, required String? password}) async {
    emit(RegisterLoading());
    if (await InternetConnectionChecker().hasConnection) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        emit(RegisterSuccess());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          emit(RegisterFailure(errMessage: 'Email Already In Use'));
        }
      } catch (e) {
        emit(RegisterFailure(errMessage: 'Something Went Wrong'));
      }
    } else {
      emit(RegisterFailure(errMessage: 'No Internet Connection'));
    }
  }

  String? validateEmail(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
}
