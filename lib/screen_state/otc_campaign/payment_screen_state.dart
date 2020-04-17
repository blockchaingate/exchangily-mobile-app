import 'dart:typed_data';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
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
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/globals.dart' as globals;
import 'package:intl/intl.dart';

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
  String prodUsdtWalletAddress = '';

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
  List<String> orderStatusList = [];
  List<OrderInfo> orderInfoList = [];
  List<OrderInfo> orderListFromApi = [];
  List<String> uiOrderStatusList = [];
  Color containerListColor;
  double orderInfoContainerHeight = 5;
  double tokenPurchaseQuantity = 0;
  List<String> currencies = ['USD', 'CAD'];
  String selectedCurrency;
  bool isConfirming = false;
  bool isTokenCalc = false;
  TextEditingController updateOrderDescriptionController =
      TextEditingController();
  double price = 0;
  Map<String, dynamic> passOrderList;

/*----------------------------------------------------------------------
                Reset lists
----------------------------------------------------------------------*/
  resetLists() {
    orderInfoList = [];
    orderListFromApi = [];
    uiOrderStatusList = [];
    orderStatusList = [];
  }

/*----------------------------------------------------------------------
                Initial logic
----------------------------------------------------------------------*/
  initState() async {
    setBusy(true);
    resetLists();
    await getCampaignOrdeList();
    selectedCurrency = currencies[0];
    if (isProduction)
      prodUsdtWalletAddress =
          environment['addresses']['campaignAddress']['USDT'];
    setBusy(false);
  }

/*----------------------------------------------------------------------
                Calculate Order list container height
----------------------------------------------------------------------*/

  calcOrderListSizedBoxHeight() {
    double height = orderInfoList.length * 45.toDouble();
    if (height < 400) {
      orderInfoContainerHeight = height;
    } else {
      orderInfoContainerHeight = 400;
    }

    log.w(
        'calcOrderListSizedBoxHeight ${orderInfoList.length}, $orderInfoContainerHeight');
  }

/*----------------------------------------------------------------------
                Radio button selection
----------------------------------------------------------------------*/

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

/*----------------------------------------------------------------------
                Verify wallet password in pop up dialog
----------------------------------------------------------------------*/

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
      String address = '';
      isProduction
          ? address = prodUsdtWalletAddress
          : address = '0xae397cfc8f67c46d533b844bfff25ad5ae89e63a';

      await walletService
          .sendTransaction(
              tickerName, seed, [0], [], address, amount, options, true)
          .then((res) async {
        log.w('Result $res');
        String txHash = res["txHash"];
        setErrorMessage(res["errMsg"]);
        if (txHash.isNotEmpty) {
          log.w('TXhash $txHash');
          sendAmountTextController.text = '';
          await createCampaignOrder(txHash, tokenPurchaseQuantity);
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
          quantity: quantity,
          price: price);
    }).catchError((err) => log.e('Campaign database service catch $err'));

    // calling api and passing the campaign order object
    await campaignService.createCampaignOrder(campaignOrder).then((res) async {
      log.w(res);
      if (res == null) {
        setErrorMessage(AppLocalizations.of(context).serverError);
        return;
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
    await campaignService
        .getUserDataFromDatabase()
        .then((res) => userData = res);
    if (userData == null) return false;
    await campaignService.getOrdersById(userData.id).then((orderList) {
      if (orderList != null) {
        resetLists();
        orderListFromApi = orderList;
        log.w('orderListFromApi length ${orderListFromApi.length}');
        orderStatusList = [
          "",
          AppLocalizations.of(context).waiting,
          AppLocalizations.of(context).paid,
          AppLocalizations.of(context).paymentReceived,
          AppLocalizations.of(context).failed,
          AppLocalizations.of(context).orderCancelled,
        ];

        for (int i = 0; i < orderListFromApi.length; i++) {
          var status = orderListFromApi[i].status;
          if (status == "1") {
            addOrderInTheList(i, int.parse(status));
          } else if (status == "2") {
            addOrderInTheList(i, int.parse(status));
          }
        }
        // Gives height to order list container
        calcOrderListSizedBoxHeight();
        log.w('${orderInfoList.length} - ${uiOrderStatusList.length}');
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

  // Add order in the order list
  addOrderInTheList(int i, int status) {
    String formattedDate = formatStringDate(orderListFromApi[i].dateCreated);
    // needed to declare orderListFromApi globally due to this funtion to keep the code DRY
    orderListFromApi[i].dateCreated = formattedDate;
    uiOrderStatusList.add(orderStatusList[status]);
    orderInfoList.add(orderListFromApi[i]);
  }

/*----------------------------------------------------------------------
                    Update order
----------------------------------------------------------------------*/

  updateOrder(String id, String quantity) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: true,
            backgroundColor: globals.walletCardColor,
            descStyle: Theme.of(context).textTheme.bodyText1,
            titleStyle: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(decoration: TextDecoration.underline)),
        context: context,
        title: AppLocalizations.of(context).updateYourOrderStatus,
        closeFunction: () {
          Navigator.of(context, rootNavigator: true).pop();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        content: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).quantity,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                UIHelper.horizontalSpaceSmall,
                Text(
                  quantity,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            TextField(
              minLines: 1,
              maxLength: 100,
              maxLengthEnforced: true,
              style: TextStyle(color: globals.white),
              controller: updateOrderDescriptionController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).paymentDescription,
                hintStyle: Theme.of(context).textTheme.bodyText1,
                labelStyle: Theme.of(context).textTheme.headline6,
                icon: Icon(
                  Icons.event_note,
                  color: globals.primaryColor,
                ),
                labelText: AppLocalizations.of(context).paymentDescriptionNote,
              ),
            ),
            // isDescription
            //     ? Text(AppLocalizations.of(context).descriptionIsRequired)
            //     : Text('')
          ],
        ),
        buttons: [
          // Confirm button
          DialogButton(
            color: globals.primaryColor,
            onPressed: () async {
              if (updateOrderDescriptionController.text.length < 10) {
                bool test = updateOrderDescriptionController.text.length < 10;
                log.w(test);
              } else {
                setBusy(true);
                await campaignService
                    .updateCampaignOrder(
                        id, updateOrderDescriptionController.text, "2")
                    .then((value) => log.w('update campaign $value'))
                    .catchError((err) => log.e('update campaign $err'));
                Navigator.of(context, rootNavigator: true).pop();
                updateOrderDescriptionController.text = '';
                await getCampaignOrdeList();
                sharedService.showInfoFlushbar(
                    'Update status',
                    'Your order status has been updated successfully',
                    Icons.check,
                    globals.green,
                    context);
                FocusScope.of(context).requestFocus(FocusNode());
                setBusy(false);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 7),
              // model.busy is not working here and same reason that it does not show the error when desc field is empty
              child: busy
                  ? Text(AppLocalizations.of(context).loading)
                  : Text(
                      AppLocalizations.of(context).confirmPayment,
                      style: Theme.of(context).textTheme.headline5,
                    ),
            ),
          ),

          // Cancel button
          DialogButton(
            color: globals.primaryColor,
            onPressed: () async {
              await campaignService
                  .updateCampaignOrder(
                      id, updateOrderDescriptionController.text, "5")
                  .then((value) => log.w('update campaign cancel $value'))
                  .catchError((err) => log.e('update campaign cancel $err'));
              Navigator.of(context, rootNavigator: true).pop();
              updateOrderDescriptionController.text = '';
              await getCampaignOrdeList();
              FocusScope.of(context).requestFocus(FocusNode());
              sharedService.showInfoFlushbar(
                  'Update status',
                  'Your order status has been cancelled successfully',
                  Icons.check,
                  globals.green,
                  context);
            },
            child: Text(
              AppLocalizations.of(context).cancelOrder,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ]).show();
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
    double usdPrice = 0;
    await campaignService.getUsdPrices().then((res) {
      if (res != null) {
        log.w(res['data']['EXG']['USD']);
        log.e(selectedCurrency);
        double exgUsdValue = res['data']['EXG']['USD'];
        if (selectedCurrency == 'CAD') {
          double cadUsdValue = res['data']['CAD']['USD'];
          usdPrice = (1 / cadUsdValue) * exgUsdValue;
          log.i('in if $usdPrice');
        } else {
          usdPrice = exgUsdValue;
          log.w('in else $usdPrice');
        }
      }
    });
    setBusy(false);
    return usdPrice;
  }

/*----------------------------------------------------------------------
                    Calculate purchased token amount
----------------------------------------------------------------------*/

  calcTokenPurchaseAmount(amount) async {
    setBusy(true);
    isTokenCalc = true;
    price = await getUsdValue();
    log.w('price $price');
    tokenPurchaseQuantity = amount / price;
    setBusy(false);
    isTokenCalc = false;
    return tokenPurchaseQuantity;
  }
}
