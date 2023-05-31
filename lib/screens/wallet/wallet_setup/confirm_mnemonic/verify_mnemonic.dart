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
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class VerifyMnemonicWalletView extends StatelessWidget {
  final List<TextEditingController> mnemonicTextController;
  final String? validationMessage;
  final int? count;

  const VerifyMnemonicWalletView(
      {required this.mnemonicTextController,
      this.validationMessage,
      this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                FlutterI18n.translate(
                    context, "warningImportOrConfirmMnemonic"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              )),
            ],
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: GridView.extent(
                  maxCrossAxisExtent: 125,
                  padding: const EdgeInsets.all(2),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  childAspectRatio: 2,
                  children: _buildTextGrid(count!, mnemonicTextController,
                      context: context))),
        ],
      ),
    );
  }

  List<Widget> _buildTextGrid(int count, controller, {BuildContext? context}) =>
      List.generate(count, (i) {
        var hintMnemonicWordNumber = i + 1;
        controller.add(TextEditingController());
        return TextField(
          inputFormatters: <TextInputFormatter>[
            LowerCaseTextFormatter(),
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            // FilteringTextInputFormatter.allow(RegExp(r'([a-z]{0,})$'))
          ],
          style: Theme.of(context!)
              .textTheme
              .headlineMedium!
              .copyWith(color: getTextColor(primaryColor)),
          controller: controller[i],
          autocorrect: true,
          cursorColor: white,
          decoration: InputDecoration(
            fillColor: primaryColor,
            filled: true,
            hintText: '$hintMnemonicWordNumber',
            hintStyle: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: getTextColor(primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: white, width: 2),
                borderRadius: BorderRadius.circular(30.0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        );
      });
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
