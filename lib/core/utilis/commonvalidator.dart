class Validators {
  static String? validateUsername(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter a name';
    }
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return 'Only letters are allowed in the name';
    }
    return null;
  }

  static String? validateStrting(String value, String name) {
    if (value.trim().isEmpty || value == 'null') {
      return 'Please enter $name';
    }
    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter a your email';
    } else if (!RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]+$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePhone(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter exactly 10 digits';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter your Password';
    } else if (!RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~]).{6,}$').hasMatch(value)) {
      return 'it contain 6 characters, one number and one special character';
    }
    return null;
  }
   static String? validateRepeatPassword(String? password, String? repeatPassword) {
    if (repeatPassword == null || repeatPassword.isEmpty) return 'Please confirm your password';
    if (password != repeatPassword) return 'Passwords do not match';
    return null;
  }
}
