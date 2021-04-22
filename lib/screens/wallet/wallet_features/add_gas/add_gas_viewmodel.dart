import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddGasViewModel extends FutureViewModel {
  BuildContext context;
  final log = getLogger('AddGasVM');
  final walletService = locator<WalletService>();
  final walletDataBaseService = locator<WalletDataBaseService>();
  final sharedService = locator<SharedService>();
  final apiService = locator<ApiService>();

  final DialogService _dialogService = locator<DialogService>();

  final amountController = TextEditingController();
  final gasPriceTextController = TextEditingController();
  final gasLimitTextController = TextEditingController();
  double gasBalance = 0.0;
  double transFee = 0.0;
  bool isAdvance = false;

  @override
  Future futureToRun() async {
    String exgAddress = await sharedService.getExgAddressFromWalletDatabase();
    return walletService.gasBalance(exgAddress);
  }

  init() {
    setBusy(true);
    gasLimitTextController.text =
        environment["chains"]["FAB"]["gasLimit"].toString();
    gasPriceTextController.text = '50';
    setBusy(false);
  }

  @override
  void onData(data) {
    log.w(data);
    setBusy(true);
    gasBalance = data;
    setBusy(false);
  }

  checkPass(double amount, context) async {
    setBusy(true);
    var gasPrice = int.tryParse(gasPriceTextController.text);
    var gasLimit = int.tryParse(gasLimitTextController.text);
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      var options = {
        "gasPrice": gasPrice ?? 50,
        "gasLimit": gasLimit ?? 800000
      };
      Uint8List seed = walletService.generateSeed(mnemonic);
      var ret = await walletService.addGasDo(seed, amount, options: options);
      log.w('res $ret');
      //{'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg}
      String formattedErrorMsg = '';
      if (ret["errMsg"] != '' && ret["errMsg"] != null) {
        String errorMsg = ret["errMsg"];

        formattedErrorMsg = firstCharToUppercase(errorMsg);
      }
      amountController.text = '';
      sharedService.alertDialog(
          (ret["errMsg"] == '')
              ? AppLocalizations.of(context).addGasTransactionSuccess
              : AppLocalizations.of(context).addGasTransactionFailed,
          (ret["errMsg"] == '') ? ret['txHash'] : formattedErrorMsg,
          isWarning: false,
          isCopyTxId: ret["errMsg"] == '' ? true : false,
          path: (ret["errMsg"] == '') ? DashboardViewRoute : '');
    } else {
      if (res.returnedText != 'Closed') {
        wrongPasswordNotification(context);
      }
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Update Transaction Fee
----------------------------------------------------------------------*/
  updateTransFee() async {
    setBusy(true);
    String fabAddress = await sharedService.getFABAddressFromWalletDatabase();
    var amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      transFee = 0.0;
      setBusy(false);
      return;
    }
    var gasPrice = int.tryParse(gasPriceTextController.text);
    var gasLimit = int.tryParse(gasLimitTextController.text);
    var options = {
      "gasPrice": gasPrice,
      "gasLimit": gasLimit,
    };
    var scarContractAddress = await getScarAddress();
    scarContractAddress = trimHexPrefix(scarContractAddress);

    var fxnDepositCallHex = '4a58db19';
    var contractInfo = await walletService.getFabSmartContract(
        scarContractAddress,
        fxnDepositCallHex,
        options['gasLimit'],
        options['gasPrice']);
    print(contractInfo);

    int utxosNeeded = 0;

    var extraAmount = contractInfo['totalFee'];

    var satoshisPerBytes = 14;

// Calculated trans fee
    var bytesPerInput = environment["chains"]["FAB"]["bytesPerInput"];
    var feePerInput = bytesPerInput * satoshisPerBytes;

    // Get Utxos

    var utxos = await apiService.getFabUtxos(fabAddress);

    var totalAmount = amount + extraAmount;

    utxosNeeded = calculateUtxosNeeded(totalAmount, utxos, extraAmount);

    var fee = (utxosNeeded) * feePerInput + (2 * 34 + 10) * satoshisPerBytes;

    transFee = ((Decimal.parse(extraAmount.toString()) +
            Decimal.parse(fee.toString()) / Decimal.parse('1e8')))
        .toDouble();
    totalAmount = totalAmount + transFee;
    utxosNeeded = calculateUtxosNeeded(totalAmount, utxos, extraAmount);
    // await walletService
    //     .getFabTransactionHex(
    //         Uint8List.fromList(
    //             [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    //         [0],
    //         contractInfo['contract'],
    //         amount,
    //         contractInfo['totalFee'],
    //         satoshisPerBytes,
    //         [],
    //         true)
    //     .then((ret) {
    //   log.w('updateTransFee $ret');
    //   if (ret != null && ret['transFee'] != null) {
    //     transFee = ret['transFee'];

    //     setBusy(false);
    //   }
    // }).catchError((onError) {
    //   setBusy(false);
    //   log.e(onError);
    // });

    setBusy(false);
  }

  int calculateUtxosNeeded(double totalAmount, List utxos, extraAmount) {
    var satoshisPerBytes = 14;

// Calculated trans fee
    var bytesPerInput = environment["chains"]["FAB"]["bytesPerInput"];
    var feePerInput = bytesPerInput * satoshisPerBytes;
    int utxosNeeded = 0;
// calculate how many utxos needed

    int i = 1;
    double sumUtxos = 0.0;
    utxos.forEach((utxo) {
      var utxoValue = utxo['value'];
      print(utxoValue);
      // double utxoValueDouble = bigNum2Double(utxo['value']);
      // print('utxoValueDouble $utxoValueDouble');
      var t = Decimal.fromInt(utxoValue) / Decimal.parse('1e8');
      print(' t ${t.toDouble()}');
      sumUtxos = sumUtxos + t.toDouble();
      log.e('totalAmount $totalAmount -- sumUtxos $sumUtxos');
      if (totalAmount <= sumUtxos) {
        utxosNeeded = i;
      }
      i++;
    });
    log.i('utxosNeeded $utxosNeeded');

    return utxosNeeded;
  }

  wrongPasswordNotification(context) {
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        red,
        context);
  }
}
