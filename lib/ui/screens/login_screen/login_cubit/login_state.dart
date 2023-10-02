part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User? user;

  LoginSuccess({this.user});
}

class LoginFailure extends LoginState {
  final String? errMessage;

  LoginFailure({required this.errMessage});
}

class ChangeObscure extends LoginState {}
