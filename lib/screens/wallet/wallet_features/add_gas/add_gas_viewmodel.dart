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
import 'package:exchangilymobileapp/utils/number_util.dart';
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
  double sliderValue = 0.0;
  bool isAmountInvalid = false;
  double totalAmount = 0.0;
  double sumUtxos = 0.0;
  String fabAddress = '';
  var scarContractAddress;
  var contractInfo;
  var utxos;
  double extraAmount;
  int satoshisPerBytes = 14;
  var bytesPerInput;
  var feePerInput;
  double fabBalance = 0.0;

  @override
  Future futureToRun() async {
    String exgAddress = await sharedService.getExgAddressFromWalletDatabase();
    return walletService.gasBalance(exgAddress);
  }

  init() async {
    setBusy(true);
    gasLimitTextController.text =
        environment["chains"]["FAB"]["gasLimit"].toString();
    gasPriceTextController.text = '50';
    bytesPerInput = environment["chains"]["FAB"]["bytesPerInput"];
    feePerInput = bytesPerInput * satoshisPerBytes;
    fabAddress = await sharedService.getFABAddressFromWalletDatabase();
    getSliderReady();
    await getFabBalance();
    setBusy(false);
  }

  getSliderReady() async {
    utxos = await apiService.getFabUtxos(fabAddress);
    scarContractAddress = await getScarAddress();
    scarContractAddress = trimHexPrefix(scarContractAddress);
    var gasPrice = int.tryParse(gasPriceTextController.text);
    var gasLimit = int.tryParse(gasLimitTextController.text);
    var options = {
      "gasPrice": gasPrice,
      "gasLimit": gasLimit,
    };
    var fxnDepositCallHex = '4a58db19';
    contractInfo = await walletService.getFabSmartContract(scarContractAddress,
        fxnDepositCallHex, options['gasLimit'], options['gasPrice']);
    extraAmount = contractInfo['totalFee'];

    utxos.forEach((utxo) {
      var utxoValue = utxo['value'];
      print(utxoValue);
      // double utxoValueDouble = bigNum2Double(utxo['value']);
      // print('utxoValueDouble $utxoValueDouble');
      var t = Decimal.fromInt(utxoValue) / Decimal.parse('1e8');
      //  print(' t ${t.toDouble()}');
      sumUtxos = sumUtxos + t.toDouble();
    });
    double amt = 0.0;
    //for (var i = 0; i < sumUtxos; i + 0.05) {
    // totalAmount =
    //     // i +
    //     extraAmount;
    // int utxosNeeded = calculateUtxosNeeded(totalAmount, utxos);
    // var fee = (utxosNeeded) * feePerInput + (2 * 34 + 10) * satoshisPerBytes;
    // transFee = ((Decimal.parse(extraAmount.toString()) +
    //         Decimal.parse(fee.toString()) / Decimal.parse('1e8')))
    //     .toDouble();
    // totalAmount = totalAmount + transFee;
    // utxosNeeded = calculateUtxosNeeded(totalAmount, utxos);
    // }
  }

  @override
  void onData(data) {
    log.w(data);
    setBusy(true);

    gasBalance = data;
    setBusy(false);
  }

  getFabBalance() async {
    setBusy(true);
    await apiService
        .getSingleWalletBalance(fabAddress, 'FAB', fabAddress)
        .then((walletBalance) {
      if (walletBalance != null) {
        fabBalance = NumberUtil().truncateDoubleWithoutRouding(
            walletBalance[0].balance,
            precision: 6);
      }
    });

    setBusy(false);
  }

  checkPass(double amount, context) async {
    setBusy(true);
    if (isAmountInvalid) {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).notice,
          "FAB ${AppLocalizations.of(context).insufficientBalance}",
          Icons.cancel,
          red,
          context);
      return;
    }
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
  updateTransFee() {
    setBusy(true);
    var amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      transFee = 0.0;
      setBusy(false);
      return;
    }

    print(contractInfo);

    int utxosNeeded = 0;

// Calculated trans fee

    // Get Utxos

    int totalUtxos = utxos.length;
    totalAmount = amount + extraAmount;
    utxosNeeded = calculateUtxosNeeded(totalAmount, utxos);
    var fee = (utxosNeeded) * feePerInput + (2 * 34 + 10) * satoshisPerBytes;
    transFee = ((Decimal.parse(extraAmount.toString()) +
            Decimal.parse(fee.toString()) / Decimal.parse('1e8')))
        .toDouble();
    totalAmount = totalAmount + transFee;
    utxosNeeded = calculateUtxosNeeded(totalAmount, utxos);
    bool isRequiredUtxoValueIsMore = totalUtxos < utxosNeeded;
    if (isRequiredUtxoValueIsMore || utxosNeeded == 0) {
      isAmountInvalid = true;
    } else {
      isAmountInvalid = false;
    }
    setBusy(false);
  }

  int calculateUtxosNeeded(double totalAmount, List utxos) {
    int utxosNeeded = 0;
    sumUtxos = 0.0;
// calculate how many utxos needed
    int i = 1;

    utxos.forEach((utxo) {
      var utxoValue = utxo['value'];
      print(utxoValue);
      // double utxoValueDouble = bigNum2Double(utxo['value']);
      // print('utxoValueDouble $utxoValueDouble');
      var t = Decimal.fromInt(utxoValue) / Decimal.parse('1e8');
      //  print(' t ${t.toDouble()}');
      sumUtxos = sumUtxos + t.toDouble();
      if (totalAmount <= sumUtxos) {
        utxosNeeded = i;
      }
      i++;
    });
    log.e('totalAmount $totalAmount -- sumUtxos $sumUtxos');
    log.i('utxosNeeded $utxosNeeded');

    return utxosNeeded;
  }

/*----------------------------------------------------------------------
                   Slider On change
----------------------------------------------------------------------*/
  sliderOnchange(newValue) {
    setBusy(true);
    sliderValue = newValue;

    // var baseCoinbalance =
    //     baseCoinExchangeBalance.unlockedAmount; //coin(asset) bal for sell
    // baseCoinbalance = roundDown(baseCoinbalance);
    // //baseCoinWalletData
    // //  .inExchange;

    // if (amount != null && amount.isNegative) {
    //   print('base balance $baseCoinbalance');

    var changeAmountWithSlider =
        ((sumUtxos - transFee) - extraAmount) * sliderValue / 100;
    //   quantity = changeBalanceWithSlider / price;
    //   String roundedQtyString =
    //       quantity.toStringAsFixed(singlePairDecimalConfig.qtyDecimal);
    // double roundedAmountDouble = double.parse(roundedQtyString);
    //   roundedQtyDouble = roundDown(roundedQtyDouble);
    //   transactionAmount = roundedQtyDouble * price;
    amountController.text = changeAmountWithSlider.toString();
    //   updateTransFee();
    //   log.w('Slider value $sliderValue');
    //   log.i('calculated tx amount $transactionAmount');
    //   log.e('Balance change with slider $changeBalanceWithSlider');
    // } else {
    //   log.e('In sliderOnchange else where quantity $amount null/empty');
    // }
    setBusy(false);
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
