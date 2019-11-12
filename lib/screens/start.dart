import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/globals.dart' as globals;

class StartScreen extends StatelessWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primary = globals.primaryColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Logo Container
        new Container(
          height: 70,
          margin: EdgeInsets.only(bottom: 10),
          child: Image.asset('assets/images/start-page/logo.png'),
        ),
        // Middle Graphics Container
        new Container(
          padding: EdgeInsets.all(20),
          child: Image.asset('assets/images/start-page/middle-design.png'),
        ),
        // Language Text and Icon Container
        new Container(
          width: 300,
          height: 50,
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.language,
                color: Colors.white,
              ),
              Text('Please choose the language',
                  style: TextStyle(
                      color: Colors.white, letterSpacing: 1.25, fontSize: 15))
            ],
          ),
        ),
        // Button Container
        new Container(
          // width: 225,
          height: 150,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // English Lang Button
                RaisedButton(
                  child: Text('English'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/importWallet');
                  },
                ),
                // Chinese Lang Button
                RaisedButton(
                  shape: StadiumBorder(
                      side: BorderSide(color: globals.primaryColor, width: 2)),
                  color: globals.secondaryColor,
                  child: Text('中文'),
                  onPressed: () {},
                )
              ]),
        )
      ],
    );
  }
}
