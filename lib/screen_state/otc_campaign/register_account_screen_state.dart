import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/cupertino.dart';

class RegisterScreenState extends BaseState {
  final log = getLogger('RegisterScreenState');

  BuildContext context;
  String errorMessage;
  bool passwordMatch;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  signUp() {}

  checkPassword() {
    passwordTextController.text == confirmPasswordTextController.text
        ? passwordMatch = true
        : passwordMatch = false;
  }
}
