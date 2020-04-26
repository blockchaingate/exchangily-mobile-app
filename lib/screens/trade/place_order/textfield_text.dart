/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';

typedef void TextChangedCallback(String labelText, String text);

class TextfieldText extends StatelessWidget {
  final String name;
  final String labelText;
  final String suffixText;
  final TextChangedCallback onTextChanged;

  TextfieldText(this.name, this.labelText, this.suffixText, this.onTextChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 61,
        child: Stack(
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24)),
                      isDense: true,
                      labelText: name == "price"
                          ? AppLocalizations.of(context).price
                          : AppLocalizations.of(context).quantity,
                      labelStyle:
                          TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (text) {
                      this.onTextChanged(name, text);
                    },
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  )
                ]),
            Positioned(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(suffixText,
                            style: TextStyle(
                                fontSize: 12, color: Colors.white70)))))
          ],
        ));
  }
}
