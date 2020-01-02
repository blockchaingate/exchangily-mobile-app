import "package:flutter/material.dart";
import '../../shared/globals.dart' as globals;

class Gas extends StatelessWidget {
  final double gasAmount;
  Gas({Key key, this.gasAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              print('gas');
              Navigator.pushNamed(context, '/addGas');
            },
            child: Icon(
              Icons.add_circle_outline,
              semanticLabel: 'Add gas',
              color: globals.primaryColor,
            )),
        Container(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "Gas: $gasAmount",
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(wordSpacing: 1.25),
          ),
        )
      ],
    );
  }
}
