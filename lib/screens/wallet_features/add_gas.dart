import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class AddGas extends StatelessWidget {
  const AddGas({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.only(start: 0),
          leading: CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          middle: Text("Add Gas",style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body:
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                      "Amount:",
                      style:  new TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0)
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color(0XFF871fff), width: 1.0)
                      ),

                        hintText: 'Enter the amount',
                        hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                    ),
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    padding: EdgeInsets.all(15),
                    color: globals.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/balance');
                    },
                    child: Text(
                      'Confirm',
                      style: Theme.of(context).textTheme.button,
                    ),
                  )
                ],
              )
            )

      );
  }
}
