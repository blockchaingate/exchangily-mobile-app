import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/utils/eth_util.dart';
import 'dart:convert';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:http/http.dart' as http;

class MoveToWalletViewmodel extends BaseState {
  final log = getLogger('MoveToWalletViewmodel');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();

  WalletInfo walletInfo;
  BuildContext context;

  String gasFeeUnit = '';
  String feeMeasurement = '';
  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  final amountController = TextEditingController();
  var kanbanTransFee;
  var minimumAmount;
  bool transFeeAdvance = false;
  double gasAmount = 0.0;
  var withdrawLimit;
  PairDecimalConfig singlePairDecimalConfig = new PairDecimalConfig();
  bool isShowErrorDetailsButton = false;
  bool isShowDetailsMessage = false;
  String serverError = '';
  List<Map<String, dynamic>> chainBalances = [];
  var ethChainBalance;
  var fabChainBalance;
  bool isWithdrawChoice = false;
  String _groupValue;
  get groupValue => _groupValue;
  bool isShowFabChainBalance = false;
  String specialTicker ='';

/*---------------------------------------------------
                      INIT
--------------------------------------------------- */
  void initState() {
    setBusy(true);
    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    setWithdrawLimit();
    kanbanGasPriceTextController.text = gasPrice.toString();
    kanbanGasLimitTextController.text = gasLimit.toString();

    kanbanTransFee = bigNum2Double(gasPrice * gasLimit);

    if (walletInfo.tickerName == 'ETH' || walletInfo.tickerName == 'USDT') {
      gasFeeUnit = 'WEI';
    } else if (walletInfo.tickerName == 'FAB') {
      gasFeeUnit = 'LIU';
      feeMeasurement = '10^(-8)';
    }
    checkGasBalance();
    getSingleCoinExchangeBal();
    getDecimalData();
    _groupValue = 'ETH';
    specialTicker = walletService.updateSpecialTokensTickerNameForTxHistory(walletInfo.tickerName)['tickerName'];
    setBusy(false);
  }

  showDetailsMessageToggle() {
    setBusy(true);
    isShowDetailsMessage = !isShowDetailsMessage;
    setBusy(false);
  }

  getDecimalData() async {
    setBusy(true);
    singlePairDecimalConfig =
        await sharedService.getSinglePairDecimalConfig(walletInfo.tickerName);
    log.i('singlePairDecimalConfig ${singlePairDecimalConfig.toJson()}');
    setBusy(false);
  }

  /*---------------------------------------------------
                      Set Withdraw Limit
--------------------------------------------------- */
  setWithdrawLimit() async {
    setBusy(true);
    withdrawLimit = environment["minimumWithdraw"][walletInfo.tickerName];
    print('wl $withdrawLimit');
    if (withdrawLimit == null) {
      await tokenListDatabaseService
          .getByTickerName(walletInfo.tickerName)
          .then((token) => withdrawLimit = double.parse(token.minWithdraw));
    }
    log.i('withdrawLimit $withdrawLimit');
    setBusy(false);
  }

/*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  checkGasBalance() async {
    String address = await sharedService.getExgAddressFromWalletDatabase();
    await walletService.gasBalance(address).then((data) {
      gasAmount = data;
      log.i('gas balance $gasAmount');
      if (gasAmount < 0.5) {
        sharedService.alertDialog(
          AppLocalizations.of(context).notice,
          AppLocalizations.of(context).insufficientGasAmount,
        );
      }
    }).catchError((onError) => log.e(onError));
    log.w('gas amount $gasAmount');
    return gasAmount;
  }

  // Check single coin exchange balance
  getSingleCoinExchangeBal() async {
    setBusy(true);
    String tickerName = '';
    if (walletInfo.tickerName == 'DSCE' || walletInfo.tickerName == 'DSC' ) {
      tickerName = 'DSC';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'BSTE' || walletInfo.tickerName == 'BST' ) {
      tickerName = 'BST';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'FABE' || walletInfo.tickerName == 'FAB' ) {
      tickerName = 'FAB';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'EXGE' || walletInfo.tickerName == 'EXG' ) {
      tickerName = 'EXG';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'USDTX') {
      tickerName = 'TRX';
      isWithdrawChoice = true;
    } else
      tickerName = walletInfo.tickerName;
    await apiService.getSingleCoinExchangeBalance(tickerName).then((res) {
      walletInfo.inExchange = res.unlockedAmount;
      log.w('exchange balance check ${walletInfo.inExchange}');
    });
    if (isWithdrawChoice) {
     await getEthChainBalance();
      tickerName == 'FAB'
          ? await getFabBalance()
          : await getFabChainBalance(tickerName);
    }
    log.w('chainBalances $chainBalances');
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        Fab Chain Balance
----------------------------------------------------------------------*/

  getFabBalance() async {
    setBusy(true);
    String fabAddress = getOfficalAddress('FAB');
    await walletService.coinBalanceByAddress('FAB', fabAddress, '').then((res) {
      log.e('fab res $res');
      fabChainBalance = res['balance'];
    });
    setBusy(false);
  }

  getFabChainBalance(String tickerName) async {
    setBusy(true);
    var address = sharedService.getEXGOfficialAddress();

    var smartContractAddress =
        environment["addresses"]["smartContract"][tickerName];
    if (smartContractAddress == null) {
      print('$tickerName contract is null so fetching from token database');
      await tokenListDatabaseService
          .getContractAddressByTickerName(tickerName)
          .then((value) {
        if (value != null) {
          if (!value.startsWith('0x'))
            smartContractAddress = '0x' + value;
          else
            smartContractAddress = value;
        }
      });
      print('official smart contract address $smartContractAddress');
    }

    String balanceInfoABI = '70a08231';

    var body = {
      'address': trimHexPrefix(smartContractAddress),
      'data': balanceInfoABI + fixLength(trimHexPrefix(address), 64)
    };
    var tokenBalance;
    var url = fabBaseUrl + 'callcontract';
    print(
        'Fab_util -- address $address getFabTokenBalanceForABI balance by address url -- $url -- body $body');

    var response = await http.post(url, body: body);
    var json = jsonDecode(response.body);
    var unlockBalance = json['executionResult']['output'];
    print('unlocl fab chain balance');
    // if (unlockBalance == null || unlockBalance == '') {
    //   return 0.0;

    var unlockInt = BigInt.parse(unlockBalance, radix: 16);

    // if ((decimal != null) && (decimal > 0)) {
    //   tokenBalance = ((unlockInt) / BigInt.parse(pow(10, decimal).toString()));
    // } else {
    tokenBalance = bigNum2Double(unlockInt);
    //   // print('tokenBalance for EXG==');
    //   // print(tokenBalance);
    // }

    // }

    fabChainBalance = tokenBalance;
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        ETH Chain Balance
----------------------------------------------------------------------*/
  getEthChainBalance() async {
    setBusy(true);
    String officialAddress = '';
    // if (walletInfo.tickerName != 'FABE')
    // in case of other eth tokens use eth official address
    officialAddress = getOfficalAddress('ETH');
    // else if (walletInfo.tickerName == 'FABE') {
    //   // in case of fabe use wallets eth address
    //   // await walletDataBaseService
    //   //     .getBytickerName('ETH')
    //   //     .then((wallet) => officialAddress = wallet.address);
    // }
    // call to get token balance
  
    await getEthTokenBalanceByAddress(officialAddress,walletInfo.tickerName == "FAB"?'FABE': walletInfo.tickerName)
        .then((res) {
      log.e('getEthChainBalance $res');
      ethChainBalance = walletInfo.tickerName == 'FABE' || walletInfo.tickerName ==  'FAB'
          ? res['balance']
          : res['tokenBalanceIe18'];
      //  chainBalances.add({'eth': res['balance']});
      // log.w(chainBalances);
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                Radio button selection
----------------------------------------------------------------------*/

  radioButtonSelection(value) async {
    setBusy(true);
    print(value);
    _groupValue = value;
    if (value == 'FAB') {
      isShowFabChainBalance = true;
      walletInfo.tokenType = 'FAB';
      log.i('chain type ${walletInfo.tokenType}');
    } else {
      isShowFabChainBalance = false;
      walletInfo.tokenType = 'ETH';
      log.i('chain type ${walletInfo.tokenType}');
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                      Verify Wallet Password
----------------------------------------------------------------------*/
  checkPass() async {
    setBusy(true);
    if (amountController.text.isEmpty) {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).minimumAmountError,
          AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
          Icons.cancel,
          red,
          context);
      setBusy(false);
      return;
    }
    await checkGasBalance();
    if (gasAmount == 0.0 || gasAmount < 0.5) {
      sharedService.alertDialog(
        AppLocalizations.of(context).notice,
        AppLocalizations.of(context).insufficientGasAmount,
      );
      setBusy(false);
      return;
    }

    var amount = double.tryParse(amountController.text);
    if (amount < withdrawLimit) {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).minimumAmountError,
          AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
          Icons.cancel,
          red,
          context);
      setBusy(false);
      return;
    }
    getSingleCoinExchangeBal();
    if (amount == null ||
        amount > walletInfo.inExchange ||
        amount == 0 ||
        amount.isNegative) {
      sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          isWarning: false);
      setBusy(false);
      return;
    }
    if (isShowFabChainBalance) {
      if (isShowFabChainBalance && amount > fabChainBalance) {
        sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
            AppLocalizations.of(context).pleaseEnterValidNumber,
            isWarning: false);
        setBusy(false);
        return;
      }
      if (!isShowFabChainBalance && amount > ethChainBalance) {
        sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
            AppLocalizations.of(context).pleaseEnterValidNumber,
            isWarning: false);
        setBusy(false);
        return;
      }
    }
    String exgAddress = await sharedService.getExgAddressFromWalletDatabase();
    setMessage('');
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var tokenType = walletInfo.tokenType;
      var coinName = walletInfo.tickerName;
      var coinAddress = isShowFabChainBalance ? exgAddress : walletInfo.address;
      // if (!isShowFabChainBalance) {
      //   amount = BigInt.tryParse(amountController.text);
      // }
      if (coinName == 'BCH') {
        await walletService.getBchAddressDetails(coinAddress).then(
            (addressDetails) => coinAddress = addressDetails['legacyAddress']);
      }

      var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
      BigInt bigIntAmount = BigInt.tryParse(amountController.text);
      log.w('Big int amount $bigIntAmount');
      await walletService
          .withdrawDo(seed, coinName, coinAddress, tokenType, bigIntAmount,
              kanbanPrice, kanbanGasLimit)
          .then((ret) {
        log.w(ret);
        bool success = ret["success"];
        if (success && ret['transactionHash'] != null) {
          String txId = ret['transactionHash'];
          log.i('txid $txId');
          amountController.text = '';
          setMessage(txId);
        } else {
          serverError = ret['data'];
          if (serverError == null || serverError == '') {
            var errMsg = AppLocalizations.of(context).serverError;
            setErrorMessage(errMsg);
            isShowErrorDetailsButton = true;
          }
        }
        sharedService.alertDialog(
            success && ret['transactionHash'] != null
                ? AppLocalizations.of(context).withdrawTransactionSuccessful
                : AppLocalizations.of(context).withdrawTransactionFailed,
            success ? "" : AppLocalizations.of(context).serverError,
            isWarning: false);
      }).catchError((err) {
        print('Withdraw catch $err');
      });
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
    setBusy(false);
  }

  showNotification(context) {
    setState(ViewState.Busy);
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        red,
        context);
    setState(ViewState.Idle);
  }

  // update Transaction Fee

  updateTransFee() async {
    setBusy(true);
    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

    var kanbanPriceBig = BigInt.from(kanbanPrice);
    var kanbanGasLimitBig = BigInt.from(kanbanGasLimit);
    var kanbanTransFeeDouble =
        bigNum2Double(kanbanPriceBig * kanbanGasLimitBig);
    print('Update trans fee $kanbanTransFeeDouble');

    kanbanTransFee = kanbanTransFeeDouble;
    setBusy(false);
  }

// Copy txid and display flushbar
  copyAndShowNotificatio(String message) {
    sharedService.copyAddress(context, message);
  }
}
