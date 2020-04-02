import 'dart:typed_data';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/models/transaction-info.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/globals.dart' as globals;

class CampaignPaymentScreenState extends BaseState {
  final log = getLogger('PaymentScreenState');
  NavigationService _navigationService = locator<NavigationService>();
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  CampaignService campaignService = locator<CampaignService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  final sendAmountTextController = TextEditingController();
  String _groupValue;
  get groupValue => _groupValue;
  String usdtToWalletAddress = '0xae397cfc8f67c46d533b844bfff25ad5ae89e63a';
  BuildContext context;
  String tickerName = '';
  String tokenType = '';
  var options = {};
  int gasPrice = 8000000000;
  int gasLimit = 100000;
  int satoshisPerBytes = 50;
  bool checkSendAmount = false;
  WalletInfo walletInfo;
  String exgWalletAddress = '';
  CampaignUserData userData;
  String errorMessage = '';
  CampaignOrder campaignOrder;
  List<TransactionInfo> transactionInfoList = [];
  Color containerListColor;
  int orderInfoContainerHeight = 430;

  // Initial logic
  initState() async {
    print('in payment screen');
    await getCampaignOrdeList();
  }

  // Radio button selection

  radioButtonSelection(value) async {
    setState(ViewState.Busy);
    print(value);
    orderInfoContainerHeight = 510;
    _groupValue = value;
    if (value != 'USD') {
      await getWallet();
    }
    setErrorMessage('');
    setState((ViewState.Idle));
  }

  navigateToDashboard() {
    _navigationService.navigateTo('/campaignDashboard');
  }

// Verify wallet password in pop up dialog
  verifyWalletPassword(double amount) async {
    setBusy(true);
    log.w(('Sending payment amount $amount'));
    var dialogResponse = await dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (dialogResponse.confirmed) {
      String mnemonic = dialogResponse.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);

      if (tickerName == 'USDT') {
        tokenType = 'ETH';
      } else if (tickerName == 'EXG') {
        tokenType = 'FAB';
      }

      options = {
        'tokenType': tokenType,
        'contractAddress': environment["addresses"]["smartContract"]
            [tickerName],
        'gasPrice': gasPrice,
        'gasLimit': gasLimit,
        'satoshisPerBytes': satoshisPerBytes
      };
      // }
      await walletService
          .sendTransaction(tickerName, seed, [0], [], usdtToWalletAddress,
              amount, options, true)
          .then((res) async {
        log.w('Result $res');
        String txHash = res["txHash"];
        errorMessage = res["errMsg"];
        if (txHash.isNotEmpty) {
          log.w('TXhash $txHash');
          sendAmountTextController.text = '';
          // String date = DateTime.now().toString();
          // Build transaction history object
          // TransactionHistory transactionHistory = new TransactionHistory(

          //     amount: amount,
          //     date: date);
          // Add transaction history object in database
          // await transactionHistoryDatabaseService
          //     .insert(transactionHistory)
          //     .then((data) => log.w('Saved in transaction history database'))
          //     .catchError(
          //         (onError) => log.e('Could not save in database $onError'));
          // timer = Timer.periodic(Duration(seconds: 55), (Timer t) {
          //   checkTxStatus(tickerName, txHash);
          // });
          await createCampaignOrder(txHash, amount);
          sharedService.alertResponse(
              AppLocalizations.of(context).sendTransactionComplete,
              '$tickerName ${AppLocalizations.of(context).isOnItsWay}');
        } else if (errorMessage.isNotEmpty) {
          log.e('Error Message: $errorMessage');
          sharedService.alertResponse(AppLocalizations.of(context).genericError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}');
          setState(ViewState.Idle);
        } else if (txHash == '' && errorMessage == '') {
          log.w('Both TxHash and Error Message are empty $errorMessage');
          sharedService.alertResponse(AppLocalizations.of(context).genericError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}');
          setBusy(false);
        }
        return txHash;
      }).timeout(Duration(seconds: 25), onTimeout: () {
        log.e('In time out');
        setState(ViewState.Idle);

        setErrorMessage(
            AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater);
        return '';
      }).catchError((error) {
        log.e('In Catch error - $error');
        sharedService.alertResponse(AppLocalizations.of(context).genericError,
            '$tickerName ${AppLocalizations.of(context).transanctionFailed}');
        //errorMessage = AppLocalizations.of(context).transanctionFailed;
        setState(ViewState.Idle);
      });
    } else if (dialogResponse.returnedText != 'Closed') {
      setState(ViewState.Idle);
      setErrorMessage(
          AppLocalizations.of(context).pleaseProvideTheCorrectPassword);
    } else {
      setState(ViewState.Idle);
    }
  }

  // Create campaign order after payment

  createCampaignOrder(String txHash, double amount) async {
    setBusy(true);

    // get exg address
    await getExgWalletAddr();

    // get login token from local storage to get the userData from local database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken');

    // get the userdata from local database using login token
    await campaignUserDatabaseService
        .getUserDataByToken(loginToken)
        .then((res) {
      userData = res;

      // contructing campaign order object to send to buy coin api request
      campaignOrder = new CampaignOrder(
          memberId: userData.id,
          walletAdd: exgWalletAddress,
          paymentType: _groupValue,
          txId: txHash,
          quantity: amount);
    }).catchError((err) => log.e('Campaign database service catch $err'));

    // calling api and passing the campaign order object
    await campaignService.createCampaignOrder(campaignOrder).then((res) async {
      log.w(res);
      if (res != null) {
        await getCampaignOrdeList();
      } else {
        log.e('Create order failed');
      }
    }).catchError((err) => log.e('Campaign service buying coin catch $err'));
    setBusy(false);
  }

  //------------------------------------------
  //        Get Campaign Order List
  //------------------------------------------
  getCampaignOrdeList() async {
    setBusy(true);
    await getExgWalletAddr();

    await campaignService
        .getOrderByWalletAddress(exgWalletAddress)
        .then((orderListFromApi) {
      // log.w(orderListFromApi.length);
      transactionInfoList = orderListFromApi;

      log.e(transactionInfoList.length);
      setBusy(false);
    }).catchError((err) {
      log.e('Campaign service getOrderByWalletAddress $err');
      setBusy(false);
    });
  }

  // Check input fields
  checkFields(context) async {
    log.i('checking fields');
    setBusy(true);
    if (sendAmountTextController.text == '' || _groupValue == null) {
      log.i('1');
      setErrorMessage('Please fill all the fields');
      setBusy(false);
      return;
    }
    double amount = double.parse(sendAmountTextController.text);
    if (amount == null ||
        !checkSendAmount ||
        amount > walletInfo.availableBalance) {
      setErrorMessage(AppLocalizations.of(context).pleaseEnterValidNumber);
      sharedService.alertResponse(AppLocalizations.of(context).invalidAmount,
          'Please enter the amount equals or less than your available wallet balance');
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      await verifyWalletPassword(amount);
    }
    setBusy(false);
  }

// Get wallet info by using which user is making the payment
  getWallet() async {
    // Get coin details which we are making transaction through like USDT
    await walletDataBaseService.getBytickerName(_groupValue).then((res) {
      tickerName = _groupValue;
      walletInfo = res;
      log.w('wallet info ${walletInfo.availableBalance}');
    });
  }

// Get exg wallet address
  getExgWalletAddr() async {
    // Get coin details which we are making transaction through like USDT
    await walletDataBaseService.getBytickerName('EXG').then((res) {
      exgWalletAddress = res.address;
      log.w('Exg wallet address $exgWalletAddress');
    });
  }

  // Check Send Amount
  checkAmount(amount) {
    setState(ViewState.Busy);
    Pattern pattern = r'^(0|(\d+)|\.(\d+))(\.(\d+))?$';
    log.e(amount);
    var res = RegexValidator(pattern).isValid(amount);
    checkSendAmount = res;
    log.w('check send amount $checkSendAmount');
    !checkSendAmount
        ? setErrorMessage('Please enter the valid amount')
        : setErrorMessage('');
    setState(ViewState.Idle);
  }

  // Order list container color according to even/odd index input from the UI list builder
  Color evenOrOddColor(int index) {
    index.isOdd
        ? containerListColor = globals.walletCardColor
        : containerListColor = globals.grey.withAlpha(20);
    return containerListColor;
  }
}
