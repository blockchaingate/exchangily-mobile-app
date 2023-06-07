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

import 'dart:typed_data';

import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart' as stringUtils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../../constants/colors.dart';

class SmartContract extends StatefulWidget {
  const SmartContract({Key? key}) : super(key: key);

  @override
  _SmartContractState createState() => _SmartContractState();
}

class _SmartContractState extends State<SmartContract> {
  final log = getLogger('SmartContract');
  String? _currentFunction = '';
  String? _smartContractName = '';
  var abis;
  var functionHex;
  var abi;

  final DialogService _dialogService = locator<DialogService>();
  WalletService? walletService = locator<WalletService>();
  SharedService? sharedService = locator<SharedService>();
  var fabUtils = FabUtils();

  List<dynamic>? inputs = [];
  var payable = false;
  TextEditingController smartContractAddressController =
      TextEditingController();
  TextEditingController payableController = TextEditingController();
  List<DropdownMenuItem<String>>? _dropDownMenuItems;
  @override
  void initState() {
    smartContractAddressController.value = TextEditingValue(
        text: environment['addresses']['smartContract']['FABLOCK']);
    onSmartContractAddressChanged(smartContractAddressController.value.text);

    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  Future getDropDownMenuItems(abis) async {
    // var smartContractABI = await getSmartContractABI('');
    List<DropdownMenuItem<String>> items = [];
    for (var abi in abis) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      if (abi['type'] == 'function') {
        items.add(DropdownMenuItem(
            value: abi['name'],
            child: Text(
              abi['name'],
              style: Theme.of(context).textTheme.headlineMedium,
            )));
      }
    }
    return items;
  }

  void changedDropDownItem(String? selectedFunction) {
    debugPrint(
        "Selected function $selectedFunction, we are going to refresh the UI");
    var inputs;
    var payable = false;
    for (var i = 0; i < abis.length; i++) {
      var item = abis[i];
      if (item['name'] == selectedFunction) {
        inputs = item['inputs'];
        abi = item;
        for (var j = 0; j < inputs.length; j++) {
          inputs[j]['controller'] = TextEditingController();
        }
        if (item['stateMutability'] == 'payable') {
          payable = true;
        }
        break;
      }
    }

    setState(() {
      payable = payable;
      inputs = inputs;
      _currentFunction = selectedFunction;
    });
  }

  onSmartContractAddressChanged(String address) async {
    var smartContractABI = await fabUtils.getSmartContractABI(address);

    abis = smartContractABI['abi'];
    functionHex = smartContractABI['functionHex'];
    var funcs = await getDropDownMenuItems(abis);
    var currentFunc;
    if ((funcs != null) && (funcs.length > 0)) {
      currentFunc = funcs[0].value;
    }

    setState(() => {
          _smartContractName = smartContractABI['Name'],
          _dropDownMenuItems = funcs,
          _currentFunction = currentFunc
        });
  }

  @override
  Widget build(BuildContext context) {
    //onSmartContractAddressChanged(myController.value.text);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            FlutterI18n.translate(context, "smartContract"),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ListView(
              children: <Widget>[
                Text(FlutterI18n.translate(context, "smartContractAddress"),
                    style: const TextStyle(color: Colors.grey, fontSize: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0XFF871fff), width: 1.0)),
                    hintText: FlutterI18n.translate(context, "enterAddress"),
                    hintStyle:
                        const TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                  controller: smartContractAddressController,
                  style: Theme.of(context).textTheme.headlineMedium,
                  onChanged: (text) {
                    onSmartContractAddressChanged(text);
                  },
                ),
                const SizedBox(height: 20),
                Text(FlutterI18n.translate(context, "smartContractName"),
                    style: const TextStyle(color: Colors.grey, fontSize: 18.0)),
                const SizedBox(height: 10),
                Text(_smartContractName ?? '',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                Text(FlutterI18n.translate(context, "function"),
                    style: const TextStyle(color: Colors.grey, fontSize: 18.0)),
                const SizedBox(height: 10),
                DropdownButton(
                  iconSize: 30,
                  elevation: 5,
                  style: Theme.of(context).textTheme.headlineLarge!,
                  isExpanded: true,
                  value: _currentFunction,
                  items: _dropDownMenuItems!.map((e) {
                    return DropdownMenuItem(
                        value: e.value,
                        child: Text(e.value.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold)));
                  }).toList(),
                  onChanged: (dynamic newValue) =>
                      changedDropDownItem(newValue),
                ),
                const SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    for (var input in inputs!)
                      Column(
                        children: <Widget>[
                          Text(input['name'],
                              style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 10),
                          TextField(
                              controller: input['controller'],
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0XFF871fff), width: 1.0)),
                                hintText: '',
                                hintStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.grey),
                              ),
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                    if (payable)
                      Column(
                        children: <Widget>[
                          Text(FlutterI18n.translate(context, "payableValue"),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 18.0)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: payableController,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0XFF871fff), width: 1.0)),
                              hintText: '',
                              hintStyle:
                                  TextStyle(fontSize: 20.0, color: Colors.grey),
                            ),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      )
                  ],
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  padding: const EdgeInsets.all(15),
                  color: globals.primaryColor,
                  textColor: Theme.of(context).hintColor,
                  onPressed: () async {
                    // var res = await AddGasDo(double.parse(myController.text));

                    for (var i = 0; i < inputs!.length; i++) {
                      var text = inputs![i]['controller'].text;
                    }
                    if (payable) {}

                    if (abi['stateMutability'] == 'view') {
                      callContract();
                    } else {
                      execContract();
                    }
                    //   debugPrint(res);
                  },
                  child: Text(
                    FlutterI18n.translate(context, "confirm"),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )
              ],
            )));
  }

  formABI() {
    String? abiHex = '';
    if (functionHex != null) {
      for (var i = 0; i < functionHex.length; i++) {
        if (functionHex[i]['name'] == _currentFunction) {
          abiHex = functionHex[i]['hex'];
        }
      }
    }

    for (var i = 0; i < inputs!.length; i++) {
      var text = inputs![i]['controller'].value.text;
      final number = int.parse(text, radix: 10);
      var hexString = number.toRadixString(16);
      abiHex = abiHex! + stringUtils.fixLength(hexString, 64);
    }
    return abiHex;
  }

  callContract() {}

  checkPass(abiHex, value, context) async {
    var res = await _dialogService.showDialog(
        title: FlutterI18n.translate(context, "enterPassword"),
        description: FlutterI18n.translate(
            context, "dialogManagerTypeSamePasswordNote"));
    if (res.confirmed!) {
      log.w('Pass matched');
      log.w(res.returnedText);
      String? mnemonic = res.returnedText;
      Uint8List seed = walletService!.generateSeed(mnemonic);

      var contractInfo = await walletService!.getFabSmartContract(
          smartContractAddressController.value.text, abiHex, 800000, 50);

      var res1 = await walletService!.getFabTransactionHex(
          seed,
          [0],
          contractInfo['contract'],
          value,
          contractInfo['totalFee'],
          14,
          [],
          false);
      var txHex = res1['txHex'];
      var errMsg = res1['errMsg'];
      String? txHash = '';
      if (txHex != null && txHex != '') {
        var res = await fabUtils.postFabTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      }
    } else {
      if (res.returnedText != 'Closed') {
        log.w('Wrong password');
        showNotification(context);
      }
    }
  }

  showNotification(context) {
    sharedService!.sharedSimpleNotification(
      FlutterI18n.translate(context, "passwordMismatch"),
      subtitle:
          FlutterI18n.translate(context, "pleaseProvideTheCorrectPassword"),
    );
  }

  execContract() async {
    var abiHex = formABI();
    abiHex = stringUtils.trimHexPrefix(abiHex);

    double value = 0;
    if (payable) {
      value = double.parse(payableController.value.text);
    }

    checkPass(abiHex, value, context);
  }
}
