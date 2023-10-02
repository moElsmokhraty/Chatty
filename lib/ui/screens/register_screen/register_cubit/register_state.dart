part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String? errMessage;

  RegisterFailure({required this.errMessage});
}

class ChangeObsecure extends RegisterState {}

class ChangeConfirmObsecure extends RegisterState {}
