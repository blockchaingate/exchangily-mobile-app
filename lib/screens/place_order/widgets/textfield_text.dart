import "package:flutter/material.dart";
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:exchangilymobileapp/localizations.dart';

typedef void TextChangedCallback(String labelText, String text);

class TextfieldText extends StatelessWidget {
  String name;
  String labelText;
  String suffixText;
  final TextChangedCallback onTextChanged;

  TextfieldText(this.name, this.labelText, this.suffixText, this.onTextChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 61,
        child:

        Stack(
          children: <Widget>[
            Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white24)
                        ),
                        isDense: true,
                        labelText: name == "price" ? AppLocalizations.of(context).price : AppLocalizations.of(context).quantity,
                        labelStyle: new TextStyle(color: Colors.white70),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      ThousandsFormatter(allowFraction: true),
                    ],
                    onChanged: (text) {
                      print("First text field: $text");
                      this.onTextChanged(name, text);
                    },
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  )
                  /*
              TextField(
                  style: TextStyle(fontSize: 18,color: Colors.white),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white10,
                            width:1
                        )
                    ),
                  )
              )
           */
                ])
            ,

            new Positioned(
                child:
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child:
                    new Align(
                        alignment: FractionalOffset.centerRight,
                        child:
                        Text(suffixText, style: TextStyle(fontSize: 18,color: Colors.white70))
                    )
                )
            )
          ],
        )
    );
    /*
    return
      Container(
        height: 40,
        child:
            Center(
              child:
              Stack(

                  children: <Widget>[

                    new Positioned(
                        child: new Align(
                            alignment: FractionalOffset.centerRight,
                            child:
                            TextField(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white10,
                                            width:1
                                        )
                                    ),
                                )
                            )
                        )),
                    new Positioned(
                        child: new Align(
                            alignment: FractionalOffset.centerRight,
                            child:
                            Text("ETH")
                        )
                    )
                    //)

                    //)
                  ]
              )
            )

      );
    */
  }
}