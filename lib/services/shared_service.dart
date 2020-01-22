import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared/globals.dart' as globals;

class SharedService {
  BuildContext context;

  Future<bool> closeApp() async {
    return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 10,
                backgroundColor: globals.walletCardColor.withOpacity(0.85),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .display3
                    .copyWith(fontWeight: FontWeight.bold),
                contentTextStyle: TextStyle(color: globals.grey),
                //  title: Text('Are you sure?'),
                content: Text(
                  'Do you want to close the app?',
                  style: TextStyle(fontSize: 16),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(color: globals.white, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes',
                        style: TextStyle(color: globals.white, fontSize: 16)),
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                  )
                ],
              );
            }) ??
        false;
  }
}
