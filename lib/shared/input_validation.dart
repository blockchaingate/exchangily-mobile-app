/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputValidation extends StatefulWidget {
  const InputValidation(
      {required this.title,
      this.inputDecoration,
      required this.inputFormatter,
      required this.keyboardType,
      required this.stringValidator,
      required this.submitText,
      this.textAlign,
      this.textfieldStyle,
      this.onSubmit});

  final String title;
  final InputDecoration? inputDecoration;
  final TextStyle? textfieldStyle;
  final TextAlign? textAlign;
  final String submitText;
  final TextInputFormatter inputFormatter;
  final TextInputType keyboardType;
  final StringValidator stringValidator;
  final ValueChanged<String>? onSubmit;

  @override
  _InputValidationState createState() => _InputValidationState();
}

class _InputValidationState extends State<InputValidation> {
  final FocusNode _focusNode = FocusNode();
  String _value = '';

  void _submit() async {
    bool valid = widget.stringValidator.isValid(_value);
    if (valid) {
      _focusNode.unfocus();
      widget.onSubmit!(_value);
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(AppLocalizations.of(context)!.inputValidation),
    );
  }

  // Widget Built Text Field

  Widget _buidTextField() {
    return TextField(
      decoration: widget.inputDecoration,
      style: widget.textfieldStyle,
      textAlign: widget.textAlign!,
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
