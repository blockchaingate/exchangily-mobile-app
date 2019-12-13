import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/environments/environment.dart';

class SmartContract extends  StatefulWidget {
  const SmartContract({Key key}) : super(key: key);

  @override
  _SmartContractState createState() => _SmartContractState();
}

class _SmartContractState extends State<SmartContract> {


  String _currentFunction;
  String _smartContractName;
  TextEditingController myController = TextEditingController();
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  @override
  void initState() {
    myController.value = TextEditingValue(text: environment['addresses']['smartContract']['FABLOCK']);
    onSmartContractAddressChanged(myController.value.text);

    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  Future getDropDownMenuItems(abis) async{

    // var smartContractABI = await getSmartContractABI('');
    List<DropdownMenuItem<String>> items = new List();
    for (var abi in abis) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: abi['name'],
          child: new Text(
            abi['name'],
              style: TextStyle(color: Colors.white70),
          )
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedFunction) {
    print("Selected function $selectedFunction, we are going to refresh the UI");

    setState(() {
     //  _currentFunction = selectedFunction;
    });
  }

  onSmartContractAddressChanged(String address) async{
    print('address is:$address');
    var smartContractABI = await getSmartContractABI(address);
    print(smartContractABI['Name']);

    var funcs = await getDropDownMenuItems(smartContractABI['abi']);
    var _currentFunc;
    if ((funcs != null) && (funcs.length > 0)) {
      _currentFunc = funcs[0].value;
    }

    setState(() => {
      this._smartContractName = smartContractABI['Name'],
      this._dropDownMenuItems = funcs,
      this._currentFunction = _currentFunc
    });
  }

  @override
  Widget build(BuildContext context) {


    //onSmartContractAddressChanged(myController.value.text);
    return Scaffold(
        appBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.only(start: 0),
          leading: CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          middle: Text(
            "Smart Contract",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ListView(
              children: <Widget>[
                Text("Smart contract address:",
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color(0XFF871fff), width: 1.0)),
                    hintText: 'Enter the address',
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                  controller: myController,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                  onChanged: (text) {
                    print('onTap');
                    onSmartContractAddressChanged(text);
                  },
                ),
                SizedBox(height: 20),

                Text("Smart contract name:",
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
                SizedBox(height: 10),
                Text("$_smartContractName",
                    style: new TextStyle(color: Colors.white, fontSize: 18.0)),
                SizedBox(height: 20),
                Text("Function:",
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
                SizedBox(height: 10),
                new DropdownButton(
                  isExpanded: true,
                  value: _currentFunction,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                ),
                SizedBox(height: 20),
                MaterialButton(
                  padding: EdgeInsets.all(15),
                  color: globals.primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    // var res = await AddGasDo(double.parse(myController.text));
                    print('res=');
                    //   print(res);
                  },
                  child: Text(
                    'Confirm',
                    style: Theme.of(context).textTheme.button,
                  ),
                )
              ],
            )));
  }
}
