import 'package:flutter/services.dart';

abstract class StringValidator {
  // need to define your own class
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator(this.regexSource);
  final String regexSource;

  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource);
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (err) {
      assert(false, err.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  final StringValidator editingValidator;
  ValidatorInputFormatter(this.editingValidator);

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = editingValidator.isValid(oldValue.text);
    final newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}
