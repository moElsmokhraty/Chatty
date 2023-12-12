import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/register_cubit/register_cubit.dart';
import 'package:chat/views/register_view/widgets/register_view_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  static const String routeName = 'register';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: const Scaffold(
        backgroundColor: Color(0xff2B475E),
        body: RegisterViewBody(),
      ),
    );
  }
}
