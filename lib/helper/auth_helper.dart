import 'package:firebase_auth/firebase_auth.dart';

void logInFireBaseAuth(String? email, String? password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email!,
    password: password!,
  );
}

void registerToFireBaseAuth(String? email, String? password) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email!,
    password: password!,
  );
}