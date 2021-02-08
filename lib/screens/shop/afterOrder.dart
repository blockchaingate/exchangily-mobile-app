import 'package:flutter/material.dart';

class AfterOrder extends StatelessWidget {
  const AfterOrder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment Success'),
        ),
        body: Container(
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width- 200,
                  height: MediaQuery.of(context).size.width- 200,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Text(
                      'Success',
                      style: TextStyle(
                          color: Color(
                            0xffffffff,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 50),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(
                        'Your oder will be delicvered soon!',
                        style: TextStyle(
                            color: Color(
                              0xffffffff,
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                ),
                SizedBox(height: 40,),
                Container(
                  margin: EdgeInsets.all(10),
                  child: FlatButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) {
                      //   return Checkout();
                      // }));
                    },
                    color: Colors.pinkAccent,
                    child: Text("Continue Shopping"),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(),
          )
        ],
      ),
    ));
  }
}
