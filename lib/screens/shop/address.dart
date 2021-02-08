import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screen_state/shop/address_state.dart';
import 'package:flutter/material.dart';
import './independent/title.dart';

class Address extends StatelessWidget {
  Address({this.address});
  final Map address;
  @override
  Widget build(BuildContext context) {
    return BaseScreen<AddressState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState(address);
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text('Address'),
              ),
              body: Container(
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    TextField(
                      controller: model.myController,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: new Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: new TextField(
                        scrollPadding :EdgeInsets.all(10.0),
                        controller: model.myController,
                        decoration: new InputDecoration(
                          hintText: '1',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
