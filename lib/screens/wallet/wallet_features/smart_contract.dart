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
import 'package:exchangilymobileapp/localizations.dart';
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

class SmartContract extends StatefulWidget {
  const SmartContract({Key? key}) : super(key: key);

  @override
  _SmartContractState createState() => _SmartContractState();
}

class _SmartContractState extends State<SmartContract> {
  final log = getLogger('SmartContract');
  String? _currentFunction;
  String? _smartContractName;
  var abis;
  var functionHex;
  late var abi;

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
              style: const TextStyle(color: Colors.white70),
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
        appBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(start: 0),
          leading: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: const Icon(
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
            AppLocalizations.of(context)!.smartContract,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0XFF1f2233),
        ),
        backgroundColor: const Color(0xFF1F2233),
        body: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ListView(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.smartContractAddress,
                    style: const TextStyle(color: Colors.grey, fontSize: 18.0)),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0XFF871fff), width: 1.0)),
                    hintText: AppLocalizations.of(context)!.enterAddress,
                    hintStyle:
                        const TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                  controller: smartContractAddressController,
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  onChanged: (text) {
                    onSmartContractAddressChanged(text);
                  },
                ),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.smartContractName,
                    style: const TextStyle(color: Colors.grey, fontSize: 18.0)),
                const SizedBox(height: 10),
                Text(_smartContractName!,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 18.0)),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.function,
                    style: const TextStyle(color: Colors.grey, fontSize: 18.0)),
                const SizedBox(height: 10),
                DropdownButton(
                  isExpanded: true,
                  value: _currentFunction,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                ),
                const SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    for (var input in inputs!)
                      Column(
                        children: <Widget>[
                          Text(input['name'],
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 18.0)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: input['controller'],
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0XFF871fff), width: 1.0)),
                              hintText: '',
                              hintStyle:
                                  TextStyle(fontSize: 20.0, color: Colors.grey),
                            ),
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      ),
                    if (payable)
                      Column(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.payableValue,
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
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      )
                  ],
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  padding: const EdgeInsets.all(15),
                  color: globals.primaryColor,
                  textColor: Colors.white,
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
                    AppLocalizations.of(context)!.confirm,
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
        title: AppLocalizations.of(context)!.enterPassword,
        description:
            AppLocalizations.of(context)!.dialogManagerTypeSamePasswordNote);
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
      AppLocalizations.of(context)!.passwordMismatch,
      subtitle: AppLocalizations.of(context)!.pleaseProvideTheCorrectPassword,
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
