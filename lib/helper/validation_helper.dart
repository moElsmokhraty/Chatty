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
