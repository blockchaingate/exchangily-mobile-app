import "package:flutter/material.dart";
import '../../shared/globals.dart' as globals;
import '../../services/wallet_service.dart';

class Gas extends  StatefulWidget {

  Gas({Key key}) : super(key: key);
  @override
  _GasState createState() => _GasState();
}

class _GasState extends State<Gas> {

  int _gasAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[

    Container(
      margin:EdgeInsets.fromLTRB(5, 5, 5, 5),
    decoration: new BoxDecoration(
        color: globals.primaryColor,
        borderRadius: new BorderRadius.circular(50)),
    child:
      IconButton(
        icon:Icon(
          Icons.add,
          color: globals.white,
          size: 20.0,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/addGas');
        },
      )
    ),
        Text(
            "Gas:$_gasAmount",
            style: Theme.of(context).textTheme.headline
        ),

      ],
    );
  }
}