import 'dart:async';
import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';

import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/order_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/globals.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:hex/hex.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/constants/colors.dart' as colors;

class MyOrdersViewModel extends ReactiveViewModel {
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_orderService];
  BuildContext context;
  final String tickerName;

  MyOrdersViewModel({this.tickerName});

  final log = getLogger('MyOrdersViewModel');

  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  TradeService tradeService = locator<TradeService>();
  OrderService _orderService = locator<OrderService>();
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  NavigationService navigationService = locator<NavigationService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();

  double filledAmount = 0;
  double filledPercentage = 0;
  String errorMessage = '';

  List<OrderModel> myAllOrders = [];
  List<OrderModel> myOpenOrders = [];
  List<OrderModel> myCloseOrders = [];
  List<OrderModel> cancelledOrders = [];
  List<List<OrderModel>> myOrdersTabBarView = [];

  List<OrderModel> get orders => _orderService.orders;
  List<OrderModel> get singlePairOrders => _orderService.singlePairOrders;

  bool isFutureError = false;

  String onClickOrderHash = '';
  PairDecimalConfig decimalConfig = new PairDecimalConfig();
  //bool get isShowAllOrders => _orderService.isShowAllOrders;
  bool isShowAllOrders = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  int skip = 0;
  int count = 10;

  bool _isOrderbookLoaded = false;
  bool get isOrderbookLoaded => _isOrderbookLoaded;
  String get orderCancelledText => _orderCancelledText;

  String _orderCancelledText;
  TextStyle orderCancelledTextStyle;

  final abiUtils = AbiUtils();
  bool isCancelling = false;

  final kanbanUtils = KanbanUtils();

  init() async {
    log.i('INIT');
    getMyOrdersByTickerName();
    await sharedService
        .getSinglePairDecimalConfig(tickerName)
        .then((decimalConfig) => decimalConfig = decimalConfig);

    _orderCancelledText = AppLocalizations.of(context).orderCancelled;
    orderCancelledTextStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(color: colors.green);
    // _orderService.swapSources();
  }

/*-------------------------------------------------------------------------------------
                      Swap Sources
-------------------------------------------------------------------------------------*/
  void swapSources(bool v) async {
    setBusy(true);
    // log.i('2 swap sources show all pairs $isShowAllOrders');
    //  _orderService.swapSources();
    isShowAllOrders = v;
    log.w('5 swap sources show all pairs $isShowAllOrders  before method');
    isShowAllOrders ? await getAllMyOrders() : await getMyOrdersByTickerName();
    setBusy(false);
  }
/*-------------------------------------------------------------------------------------
                        Pull to refresh
-------------------------------------------------------------------------------------*/

  void onRefresh() async {
    setBusy(true);
    log.e('in refreshing orders');

    isShowAllOrders ? await getAllMyOrders() : await getMyOrdersByTickerName();
    refreshController.refreshCompleted();
    setBusy(false);
  }

  void onLoading() async {
    setBusy(true);
    log.e('in loading new orders -- Skip $skip');

    if (isShowAllOrders) {
      if (myAllOrders.length == 10)
        skip += 10;
      else
        skip = 0;
      await getAllMyOrders();
    } else {
      if (singlePairOrders.length == 10)
        skip += 10;
      else
        skip = 0;
      await getMyOrdersByTickerName();
    }
    log.i('skip count $skip');
    _refreshController.loadComplete();
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                      Clear order lists
-------------------------------------------------------------------------------------*/

  clearOrderLists() {
    myAllOrders = [];
    myOpenOrders = [];
    myCloseOrders = [];
    myOrdersTabBarView = [];
    cancelledOrders = [];
  }

/*-------------------------------------------------------------------------------------
                      Get All Orders
-------------------------------------------------------------------------------------*/
  getAllMyOrders() async {
    setBusy(true);
    isFutureError = false;
    String exgAddress = await getExgAddress();

    clearOrderLists();
    await _orderService.getMyOrders(exgAddress, skip: skip).then((data) {
      if (data != null) {
        myAllOrders = data;
        log.e('getAllMyOrders length ${myAllOrders.length}');
        data.forEach((element) {
          /// 'amount' = orderQuantity,
          /// 'filledAmount' = filledQuantity
          // filledAmount =
          //     doubleAdd(element.orderQuantity, element.filledQuantity);
          // filledPercentage = (element.filledQuantity *
          //     100 /
          //     doubleAdd(element.filledQuantity, element.orderQuantity));

          if (element.isActive) {
            myOpenOrders.add(element);
          } else if (!element.isActive && !element.isCancelled) {
            myCloseOrders.add(element);
          } else if (element.isCancelled) {
            cancelledOrders.add(element);
          }
        });
        log.w('getAllMyOrders open orders ${myOpenOrders.length}');
        log.w('getAllMyOrders close orders ${myCloseOrders.length}');
        log.w(
            'getMyOrdersByTickerName cancelledOrders  ${cancelledOrders.length}');
        // Add order lists to orders tab bar view
        myOrdersTabBarView = [
          myAllOrders,
          myOpenOrders,
          myCloseOrders,
          cancelledOrders
        ];
      }
    }).catchError((err) {
      isFutureError = true;
      log.e('getAllMyOrders $err');
    });
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                      Get orders by tickername
-------------------------------------------------------------------------------------*/
  getMyOrdersByTickerName() async {
    setBusy(true);

    clearOrderLists();
    isFutureError = false;
    String exgAddress = await getExgAddress();

    //return
    await _orderService
        .getMyOrdersByTickerName(exgAddress, tickerName, skip: skip)
        .then((value) {
      log.e('getMyOrdersByTickerName order length ${singlePairOrders.length}');
      singlePairOrders.forEach((element) {
        myAllOrders = singlePairOrders;

        /// 'amount' = orderQuantity,
        /// 'filledAmount' = filledQuantity
        // filledAmount =
        //     doubleAdd(element.orderQuantity, element.filledQuantity);
        // filledPercentage = (element.filledQuantity *
        //     100 /
        //     doubleAdd(element.filledQuantity, element.orderQuantity));
        if (element.isActive) {
          myOpenOrders.add(element);
          //  log.e('Close orders ${myOpenOrders.length}');
        } else if (!element.isActive && !element.isCancelled) {
          myCloseOrders.add(element);
        } else if (element.isCancelled) {
          cancelledOrders.add(element);
        }

        // Add order lists to orders tab bar view
      });
      log.w('getMyOrdersByTickerName open orders ${myOpenOrders.length}');
      log.w('getMyOrdersByTickerName close orders ${myCloseOrders.length}');
      log.w(
          'getMyOrdersByTickerName cancelledOrders  ${cancelledOrders.length}');
      myOrdersTabBarView = [
        myAllOrders,
        myOpenOrders,
        myCloseOrders,
        cancelledOrders
      ];
      // }
      // }).catchError((err) {
      //   isFutureError = true;
      //   log.e('getMyOrdersByTickerName $err');
      // });
      // .then((value) => onData(value));
      //return myAllOrders;
      setBusy(false);
    }).catchError((err) {
      log.e('Catch getMyOrdersByTickerName');
      setBusy(false);
    });
  }

  // Get Exg address from wallet database
  Future<String> getExgAddress() async {
    var exgWallet = await walletDataBaseService.getWalletBytickerName('EXG');
    return exgWallet.address;
  }

  // void swapSources1() async {
  //   setBusy(true);
  //   log.i('AAA swap sources show all pairs $isShowAllOrders');
  //   // _showCurrentPairOrders = !_showCurrentPairOrders;
  //   // !_showCurrentPairOrders
  //   _orderService.swapSources();
  //   log.w('BBB swap sources show all pairs $isShowAllOrders  before method');
  //   // isShowAllOrders ? await getAllMyOrders() : await getMyOrdersByTickerName();
  //   isSwitch = isShowAllOrders;
  //   log.i(
  //       'CCC swap sources show all pairs $isShowAllOrders  after method -- swtich   $isSwitch');

  //   notifyListeners();
  //   setBusy(false);
  // }

/*-------------------------------------------------------------------------------------
                      On Data
-------------------------------------------------------------------------------------*/
  void onData(List<OrderModel> data) {
    setBusy(true);
    if (data != null) {
      myAllOrders = data;
      log.e('My order length ${myAllOrders.length}');
      data.forEach((element) {
        /// 'amount' = orderQuantity,
        /// 'filledAmount' = filledQuantity
        filledAmount = doubleAdd(element.orderQuantity, element.filledQuantity);
        filledPercentage = (element.filledQuantity *
            100 /
            doubleAdd(element.filledQuantity, element.orderQuantity));

        if (element.isActive) {
          myOpenOrders.add(element);
          //  log.e('Close orders ${myOpenOrders.length}');
        } else if (!element.isActive) {
          myCloseOrders.add(element);
          //  log.w('Close orders ${myCloseOrders.length}');
        }

        // Add order lists to orders tab bar view
      });
      log.w('open orders ${myOpenOrders.length}');
      log.w('close orders ${myCloseOrders.length}');
      myOrdersTabBarView = [myAllOrders, myOpenOrders, myCloseOrders];
    }
    setBusy(false);
  }

  void onError(error) {
    isFutureError = true;
    log.e('Future error $error');
    errorMessage = error.toString();
  }

/*-------------------------------------------------------------------------------------
                      Password mismatch notice
-------------------------------------------------------------------------------------*/
  noticePasswordMismatch(context) {
    return walletService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        colors.red,
        context);
  }

/*-------------------------------------------------------------------------------------
                      Check Password
-------------------------------------------------------------------------------------*/
  checkPass(context, orderHash) async {
    setBusyForObject(onClickOrderHash, true);
    isCancelling = true;
    onClickOrderHash = orderHash;
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);

      var txHex = await txHexforCancelOrder(seed, orderHash);
      var resKanban = await kanbanUtils.sendKanbanRawTransaction(txHex);
      if (resKanban != null && resKanban["transactionHash"] != null) {
        log.w('resKanban=== $resKanban');

        // walletService.showInfoFlushbar(
        //     AppLocalizations.of(context).orderCancelled,
        //     'txid:' + resKanban["transactionHash"],
        //     Icons.info,
        //     colors.green,
        //     context);
        Timer.periodic(Duration(seconds: 2), (timer) async {
          var res =
              await tradeService.getTxStatus(resKanban["transactionHash"]);
          if (res != null) {
            String status = res['status'];
            bool txStatus = status == '0x1';
            log.i('RES $res -- bool $txStatus');
            if (status == '0x1') {
              setBusy(true);

              isShowAllOrders
                  ? await getAllMyOrders()
                  : await getMyOrdersByTickerName();

              setBusy(false);
              isCancelling = false;
              setBusyForObject(onClickOrderHash, false);

              tradeService.setBalanceRefresh(true);
            }

            timer.cancel();
            showSimpleNotification(
                Center(
                  child:
                      Text(orderCancelledText, style: orderCancelledTextStyle),
                ),
                position: NotificationPosition.bottom);
            // _dialogService.showBasicDialog(
            //     title: orderCancelledText, description: '', buttonTitle: 'Ok');
          }
        });

        // Future.delayed(new Duration(seconds: 3), () async {
        //   _orderService.swapSources();
        // });
      }
    } else if (!res.confirmed && res.returnedText != 'Closed') {
      log.e('wrong password');
      showSimpleNotification(
        Center(
            child: Text(
                AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
                style: Theme.of(context).textTheme.bodyText2)),
      );
    } else {
      if (res.returnedText == 'Closed') {
        // Flushbar(
        //   backgroundColor: colors.secondaryColor.withOpacity(0.75),
        //   title: AppLocalizations.of(context).passwordMismatch,
        //   message: AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        //   icon: Icon(
        //     Icons.cancel,
        //     size: 24,
        //     color: colors.primaryColor,
        //   ),
        //   leftBarIndicatorColor: colors.red,
        //   duration: Duration(seconds: 3),
        // ).show(context);

        log.i('dialog closed by user');
      }
    }

    onClickOrderHash = '';

    setBusy(false);
  }

  // Cancel order

  txHexforCancelOrder(seed, orderHash) async {
    String exgAddress = await getExgAddress();
    var abiHex = '7489ec23' + trimHexPrefix(orderHash);
    var nonce = await kanbanUtils.getNonce(exgAddress);

    var keyPairKanban = getExgKeyPair(seed);
    var exchangilyAddress = await kanbanUtils.getExchangilyAddress();
    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        exchangilyAddress,
        nonce,
        environment["chains"]["KANBAN"]["gasPrice"],
        environment["chains"]["KANBAN"]["gasLimit"]);
    return txKanbanHex;
  }
}
