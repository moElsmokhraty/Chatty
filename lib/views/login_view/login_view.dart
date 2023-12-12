import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/login_view_body.dart';
import '../../cubits/login_cubit/login_cubit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const Scaffold(
        backgroundColor: Color(0xff2B475E),
        body: LoginViewBody(),
      ),
    );
  }
}
