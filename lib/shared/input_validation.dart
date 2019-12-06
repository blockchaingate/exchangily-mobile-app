import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputValidation extends StatefulWidget {
  InputValidation(
      {@required this.title,
      this.inputDecoration,
      @required this.inputFormatter,
      @required this.keyboardType,
      @required this.stringValidator,
      @required this.submitText,
      this.textAlign,
      this.textfieldStyle,
      this.onSubmit});

  final String title;
  final InputDecoration inputDecoration;
  final TextStyle textfieldStyle;
  final TextAlign textAlign;
  final String submitText;
  final TextInputFormatter inputFormatter;
  final TextInputType keyboardType;
  final StringValidator stringValidator;
  final ValueChanged<String> onSubmit;

  @override
  _InputValidationState createState() => _InputValidationState();
}

class _InputValidationState extends State<InputValidation> {
  FocusNode _focusNode = FocusNode();
  String _value = '';

  void _submit() async {
    bool valid = widget.stringValidator.isValid(_value);
    if (valid) {
      _focusNode.unfocus();
      widget.onSubmit(_value);
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('input validation'),
    );
  }

  // Widget Built Text Field

  Widget _buidTextField() {
    return TextField(
      decoration: widget.inputDecoration,
      style: widget.textfieldStyle,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      autofocus: true,
      textInputAction: TextInputAction.done,
      inputFormatters: [widget.inputFormatter],
      focusNode: _focusNode,
      onChanged: (value) {
        setState(() => _value = value);
      },
      onEditingComplete: _submit,
    );
  }
}

// Widget Build Content
