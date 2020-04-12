import 'dart:typed_data';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/models/campaign/order_info.dart';
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
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  CampaignOrder campaignOrder;
  List<OrderInfo> orderInfoList = [];
  Color containerListColor;
  int orderInfoContainerHeight = 455;
  List<String> orderStatusList = [];
  List<String> uiOrderStatusList = [];
  double tokenPurchaseQuantity = 0;
  List<String> currencies = ['USD', 'CAD'];
  String selectedCurrency;
  bool isConfirming = false;
  bool isTokenCalc = false;
  TextEditingController updateOrderDescriptionController =
      TextEditingController();
  // Initial logic
  initState() async {
    setBusy(true);
    print('in payment screen');
    await getCampaignOrdeList();
    selectedCurrency = currencies[0];
    setBusy(false);
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
      isConfirming = true;
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
        setErrorMessage(res["errMsg"]);
        if (txHash.isNotEmpty) {
          log.w('TXhash $txHash');
          sendAmountTextController.text = '';
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
          isConfirming = false;
        }
        return txHash;
      }).timeout(Duration(seconds: 25), onTimeout: () {
        log.e('In time out');
        setBusy(false);
        isConfirming = false;

        setErrorMessage(
            AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater);
        return '';
      }).catchError((error) {
        log.e('In Catch error - $error');
        sharedService.alertResponse(AppLocalizations.of(context).genericError,
            '$tickerName ${AppLocalizations.of(context).transanctionFailed}');
        setBusy(false);
        isConfirming = false;
      });
    } else if (dialogResponse.returnedText != 'Closed') {
      setState(ViewState.Idle);
      setErrorMessage(
          AppLocalizations.of(context).pleaseProvideTheCorrectPassword);
    } else {
      setBusy(false);
      isConfirming = false;
    }
  }

/*----------------------------------------------------------------------
                Create campaign order after payment
----------------------------------------------------------------------*/

  createCampaignOrder(String txHash, double quantity) async {
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
          quantity: quantity);
    }).catchError((err) => log.e('Campaign database service catch $err'));

    // calling api and passing the campaign order object
    await campaignService.createCampaignOrder(campaignOrder).then((res) async {
      log.w(res);
      if (res == null) {
        setErrorMessage(AppLocalizations.of(context).serverError);
        return false;
      } else if (res['message'] != null) {
        setBusy(false);
        isConfirming = false;
        setErrorMessage(AppLocalizations.of(context).createOrderFailed);
      } else {
        log.e(res['orderNum']);
        var orderNumber = res['orderNum'];
        if (_groupValue == 'USD') {
          sharedService.alertResponse(
              AppLocalizations.of(context).orderCreatedSuccessfully,
              '${AppLocalizations.of(context).orderCreatedSuccessfully} $orderNumber ${AppLocalizations.of(context).afterHyphenWhenYouMakePayment}');
        } else {
          sharedService.alertResponse(AppLocalizations.of(context).success,
              AppLocalizations.of(context).yourOrderHasBeenCreated);
        }
        await getCampaignOrdeList();
      }
    }).catchError((err) {
      log.e('Campaign service buying coin catch $err');
      setBusy(false);
      isConfirming = false;
    });
    setBusy(false);
    isConfirming = false;
  }

/*----------------------------------------------------------------------
                Get Campaign Order List
----------------------------------------------------------------------*/
  getCampaignOrdeList() async {
    setBusy(true);
    // await getExgWalletAddr();
    await campaignService
        .getUserDataFromDatabase()
        .then((res) => userData = res);
    if (userData == null) return false;
    await campaignService.getOrdersById(userData.id).then((orderListFromApi) {
      if (orderListFromApi != null) {
        orderInfoList = orderListFromApi;
        log.w(orderInfoList.length);
        orderStatusList = [
          AppLocalizations.of(context).waiting,
          AppLocalizations.of(context).paid,
          AppLocalizations.of(context).paymentReceived,
          AppLocalizations.of(context).failed,
          AppLocalizations.of(context).orderCancelled,
        ];

        for (int i = 0; i < orderInfoList.length; i++) {
          var status = orderInfoList[i].status;

          if (status == "1") {
            uiOrderStatusList.add(orderStatusList[0]);
          } else if (status == "2") {
            uiOrderStatusList.add(orderStatusList[1]);
          } else if (status == "3") {
            uiOrderStatusList.add(orderStatusList[2]);
          } else if (status == "4") {
            uiOrderStatusList.add(orderStatusList[3]);
          } else {
            uiOrderStatusList.add(orderStatusList[4]);
          }
        }
      } else {
        log.e('Api result null');
        setErrorMessage(AppLocalizations.of(context).loadOrdersFailed);
        setBusy(false);
      }
    }).catchError((err) {
      log.e('getCampaignOrdeList $err');
      setBusy(false);
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Status popup to Update order
----------------------------------------------------------------------*/

  updateOrder(id, status) async {
    log.w('$id, ${orderInfoList[status].status}');
    var statusCode = orderInfoList[status].status;
    if (statusCode == '1' || statusCode == '2') {
      var dialogResponse = await dialogService.showOrderUpdateDialog(
          title: AppLocalizations.of(context).updateYourOrderStatus,
          description: AppLocalizations.of(context).paymentDescriptionNote,
          confirmOrder: AppLocalizations.of(context).confirmPayment,
          cancelOrder: AppLocalizations.of(context).cancelOrder);
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         bool isDescription = false;

      //          Alert(
      //          //   contentPadding: EdgeInsets.all(0.0),
      //         //    backgroundColor: globals.walletCardColor,
      //          //   scrollable: false,
      //             // style: AlertStyle(
      //             //     animationType: AnimationType.grow,
      //             //     isOverlayTapDismiss: true,
      //             //     backgroundColor: globals.walletCardColor,
      //             //     descStyle: Theme.of(context).textTheme.bodyText1,
      //             //     titleStyle: Theme.of(context)
      //             //         .textTheme
      //             //         .headline4
      //             //         .copyWith(decoration: TextDecoration.underline)),
      //              context: context,
      //             title: AppLocalizations.of(context).updateYourOrderStatus,
      //             // closeFunction: () {
      //             //   Navigator.of(context, rootNavigator: true).pop();
      //             //   FocusScope.of(context).requestFocus(FocusNode());
      //             // },
      //             content: StatefulBuilder(
      //                 builder: (BuildContext context, StateSetter localState) {
      //               return Column(
      //                 children: <Widget>[
      //                   TextField(
      //                     minLines: 1,
      //                     maxLength: 100,
      //                     maxLengthEnforced: true,
      //                     style: TextStyle(color: globals.white),
      //                     controller: updateOrderDescriptionController,
      //                     obscureText: false,
      //                     decoration: InputDecoration(
      //                       hintText:
      //                           AppLocalizations.of(context).paymentDescription,
      //                       hintStyle: Theme.of(context).textTheme.bodyText1,
      //                       labelStyle: Theme.of(context).textTheme.headline6,
      //                       icon: Icon(
      //                         Icons.event_note,
      //                         color: globals.primaryColor,
      //                       ),
      //                       labelText: AppLocalizations.of(context)
      //                           .paymentDescriptionNote,
      //                     ),
      //                   ),
      //                   isDescription
      //                       ? Text(
      //                           AppLocalizations.of(context)
      //                               .descriptionIsRequired,
      //                           style: TextStyle(color: Colors.red),
      //                         )
      //                       : Text(''),

      //                   // Confirm button

      //                   isDescription
      //                       ? DialogButton(
      //                           color: globals.primaryColor,
      //                           onPressed: () async {},
      //                           child: Padding(
      //                               padding: const EdgeInsets.symmetric(
      //                                   vertical: 2.0, horizontal: 7),
      //                               // model.busy is not working here and same reason that it does not show the error when desc field is empty
      //                               child: Text(
      //                                   AppLocalizations.of(context).loading)),
      //                         )
      //                       : DialogButton(
      //                           color: globals.primaryColor,
      //                           onPressed: () async {
      //                             if (updateOrderDescriptionController
      //                                     .text.length <
      //                                 10) {
      //                               bool test = updateOrderDescriptionController
      //                                       .text.length <
      //                                   10;
      //                               log.w(test);
      //                               localState(() => isDescription = true);
      //                             } else {
      //                               await campaignService
      //                                   .updateCampaignOrder(
      //                                       id,
      //                                       updateOrderDescriptionController.text,
      //                                       "2")
      //                                   .then((value) async =>
      //                                       await getCampaignOrdeList());
      //                               Navigator.of(context, rootNavigator: true)
      //                                   .pop();
      //                               updateOrderDescriptionController.text = '';
      //                               localState(() => isDescription = false);
      //                               FocusScope.of(context)
      //                                   .requestFocus(FocusNode());
      //                             }
      //                           },
      //                           child: Padding(
      //                             padding: const EdgeInsets.symmetric(
      //                                 vertical: 2.0, horizontal: 7),
      //                             // model.busy is not working here and same reason that it does not show the error when desc field is empty
      //                             child: busy
      //                                 ? Text(AppLocalizations.of(context).loading)
      //                                 : Text(
      //                                     AppLocalizations.of(context)
      //                                         .confirmPayment,
      //                                     style: Theme.of(context)
      //                                         .textTheme
      //                                         .headline4,
      //                                   ),
      //                           ),
      //                         ),
      //                   UIHelper.verticalSpaceSmall,
      //                   // Cancel button
      //                   DialogButton(
      //                     color: globals.primaryColor,
      //                     onPressed: () async {
      //                       await campaignService
      //                           .updateCampaignOrder(id,
      //                               updateOrderDescriptionController.text, "5")
      //                           .then((value) => getCampaignOrdeList());
      //                       Navigator.pop(context);
      //                       FocusScope.of(context).requestFocus(FocusNode());
      //                     },
      //                     child: Text(
      //                       AppLocalizations.of(context).cancelOrder,
      //                       style: Theme.of(context).textTheme.headline4,
      //                     ),
      //                   ),
      //                 ],
      //               );
      //             }),
      //            // actions: []);
      //         //.show();
      //       });
      // }
    }
  }
/*----------------------------------------------------------------------
                    Check input fields
----------------------------------------------------------------------*/

  checkFields(context) async {
    log.i('checking fields');
    if (sendAmountTextController.text == '' || _groupValue == null) {
      setErrorMessage(AppLocalizations.of(context).pleaseFillAllTheFields);
      return;
    }
    setErrorMessage('');
    double amount = double.parse(sendAmountTextController.text);
    // USD Select
    if (_groupValue == 'USD') {
      isConfirming = true;
      await createCampaignOrder("", tokenPurchaseQuantity);

      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      if (amount == null ||
          !checkSendAmount ||
          amount > walletInfo.availableBalance) {
        setErrorMessage(AppLocalizations.of(context).pleaseEnterValidNumber);
        sharedService.alertResponse(AppLocalizations.of(context).invalidAmount,
            AppLocalizations.of(context).pleaseEnterAmountLessThanYourWallet);
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
        await verifyWalletPassword(amount);
      }
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
        Get wallet info by using which user is making the payment
----------------------------------------------------------------------*/

  getWallet() async {
    // Get coin details which we are making transaction through like USDT
    await walletDataBaseService.getBytickerName(_groupValue).then((res) {
      tickerName = _groupValue;
      walletInfo = res;
      log.w('wallet info ${walletInfo.availableBalance}');
    });
  }

/*----------------------------------------------------------------------
                    Get exg wallet address
----------------------------------------------------------------------*/

  getExgWalletAddr() async {
    // Get coin details which we are making transaction through like USDT
    await walletDataBaseService.getBytickerName('EXG').then((res) {
      exgWalletAddress = res.address;
      log.w('Exg wallet address $exgWalletAddress');
    });
  }

/*----------------------------------------------------------------------
                    Check Send Amount
----------------------------------------------------------------------*/

  checkAmount(amount) async {
    setBusy(true);
    Pattern pattern = r'^(0|(\d+)|\.(\d+))(\.(\d+))?$';
    var res = RegexValidator(pattern).isValid(amount);
    checkSendAmount = res;
    if (!checkSendAmount) {
      setErrorMessage(AppLocalizations.of(context).invalidAmount);
    } else {
      setErrorMessage('');
      double castedAmount = double.parse(amount);
      await calcTokenPurchaseAmount(castedAmount);
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Order List color
----------------------------------------------------------------------*/
  // Order list container color according to even/odd index input from the UI list builder
  Color evenOrOddColor(int index) {
    index.isOdd
        ? containerListColor = globals.walletCardColor
        : containerListColor = globals.grey.withAlpha(20);
    return containerListColor;
  }

/*----------------------------------------------------------------------
    Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
----------------------------------------------------------------------*/

  Future<double> getUsdValue() async {
    setBusy(true);
    double usdValue = 0;
    await campaignService.getUsdPrices().then((res) {
      if (res != null) {
        log.w(res['data']['EXG']['USD']);
        log.e(selectedCurrency);
        if (selectedCurrency == 'CAD') {
          double cadUsdValue = res['data']['CAD']['USD'];
          double exgUsdValue = res['data']['EXG']['USD'];
          usdValue = (1 / cadUsdValue) * exgUsdValue;
          log.i('in if $usdValue');
        } else {
          usdValue = res['data']['EXG']['USD'];
          log.w('in else $usdValue');
        }
      }
    });
    setBusy(false);
    return usdValue;
  }

/*----------------------------------------------------------------------
                    Calculate purchased token amount
----------------------------------------------------------------------*/

  calcTokenPurchaseAmount(amount) async {
    setBusy(true);
    isTokenCalc = true;
    double price = await getUsdValue();
    tokenPurchaseQuantity = amount / price;
    setBusy(false);
    isTokenCalc = false;
    return tokenPurchaseQuantity;
  }
}
