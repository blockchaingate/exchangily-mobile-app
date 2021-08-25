/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';

import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';

import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';

import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:keccak/keccak.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:random_string/random_string.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:stacked/stacked.dart';
// import 'package:web_socket_channel/io.dart';

import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:convert/convert.dart';
import 'package:hex/hex.dart';
import 'dart:core';

class BuySellViewModel extends StreamViewModel with ReactiveServiceMixin {
  final tickerNameFromRoute;
  BuySellViewModel({this.tickerNameFromRoute});

  @override
  List<ReactiveServiceMixin> get reactiveServices => [tradeService];
  bool get isRefreshBalance => tradeService.isRefreshBalance;
  // double get quantityFromTradeService => tradeService.quantity;

  final log = getLogger('BuySellViewModel');
  List<WalletInfo> walletInfo;
  WalletInfo targetCoinWalletData;
  WalletInfo baseCoinWalletData;
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  TradeService tradeService = locator<TradeService>();
  WalletDataBaseService databaseService = locator<WalletDataBaseService>();
  NavigationService navigationService = locator<NavigationService>();

  BuildContext context;

  bool bidOrAsk;
  String baseCoinName;
  String targetCoinName;

  TextEditingController kanbanGasPriceTextController = TextEditingController();
  TextEditingController kanbanGasLimitTextController = TextEditingController();
  TextEditingController quantityTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();

  double kanbanTransFee = 0.0;
  bool transFeeAdvance = false;

  DialogService _dialogService = locator<DialogService>();
  double currentPrice = 0;
  double currentQuantity = 0;
  double sliderValue = 10.0;
  double price = 0.0;
  double quantity;

  String exgAddress;

  double transactionAmount = 0;

  ApiService apiService = locator<ApiService>();

  String tickerName = '';

  //Price passedPair;
  GlobalKey globalKeyOne;
  GlobalKey globalKeyTwo;
  var storageService = locator<LocalStorageService>();
  double unlockedAmount;
  double lockedAmount;
  ExchangeBalanceModel targetCoinExchangeBalance;
  ExchangeBalanceModel baseCoinExchangeBalance;
  bool isReloadMyOrders = false;
  String pairSymbolWithSlash = '';

  bool _isOrderbookLoaded = false;
  bool get isOrderbookLoaded => _isOrderbookLoaded;
  PairDecimalConfig singlePairDecimalConfig = new PairDecimalConfig();
  Orderbook orderbook = new Orderbook();
  final coinUtils = CoinUtils();
  final abiUtils = AbiUtils();
  double gasAmount = 0.0;

  @override
  Stream get stream =>
      tradeService.getOrderBookStreamByTickerName(tickerNameFromRoute);

  @override
  transformData(data) {
    log.w('transformData -- data $data');
    var jsonDynamic = jsonDecode(data);
    orderbook = Orderbook.fromJson(jsonDynamic);
    log.e(
        'OrderBook result  -- ${orderbook.buyOrders.length} ${orderbook.sellOrders.length}');
  }

  @override
  void onData(data) {
    log.i('data ready $dataReady');
    initialTextfieldsFill();
  }

  @override
  void onError(error) {
    log.e('Orderbook Stream Error $error');
  }

  @override
  void onCancel() {
    log.e('Orderbook Stream closed');
    tradeService
        .orderbookChannel(tickerName)
        .sink
        .close()
        .then((value) => log.w('Orderbook channel closed'));
  }

  init() async {
    setBusy(true);
    setDefaultGasPrice();
    sharedService.context = context;
    // getOrderbookLoadedStatus();

    exgAddress = await sharedService.getExgAddressFromWalletDatabase();

    await getDecimalPairConfig();

    transFeeAdvance = false;
    await getGasBalance();
    setBusy(false);
  }

/*---------------------------------------------------
                      Get gas balance
--------------------------------------------------- */

  getGasBalance() async {
    String address = await sharedService.getExgAddressFromWalletDatabase();
    await walletService.gasBalance(address).then((data) {
      gasAmount = data;
      if (gasAmount == 0) {
        sharedService.alertDialog(
          AppLocalizations.of(context).notice,
          AppLocalizations.of(context).insufficientGasAmount,
        );
      }
    }).catchError((onError) => log.e(onError));
    log.w('gas amount $gasAmount');
    return gasAmount;
  }

// /*----------------------------------------------------------------------
//                     Refresh balance after cancelling order
// ----------------------------------------------------------------------*/
  Widget refreshBalanceAfterCancellingOrder() {
    getSingleCoinExchangeBalanceFromAll(targetCoinName, baseCoinName);

    return sharedService.loadingIndicator();
  }

/*----------------------------------------------------------------------
                    get orderbook loaded status
----------------------------------------------------------------------*/
  void getOrderbookLoadedStatus() {
    int counter = 0;

    Timer.periodic(Duration(seconds: 1), (timer) {
      log.i('getOrderbookLoadedStatus timer started');
      _isOrderbookLoaded = tradeService.isOrderbookLoaded;
      if (_isOrderbookLoaded) {
        setBusy(true);
        // price = priceFromTradeService;
        //  quantity = quantityFromTradeService;
        priceTextController.text = price.toString();
        //   quantityTextController.text = quantityFromTradeService.toString();
        timer.cancel();
        log.i(
            'getOrderbookLoadedStatus timer cancel -- price $price -- controller ${priceTextController.text}');
      }
      setBusy(false);
      counter++;
      log.w('getOrderbookLoadedStatus $isOrderbookLoaded');
      if (counter == 20) timer.cancel();
    });
  }

/*----------------------------------------------------------------------
                Single coin exchange balance using old api
----------------------------------------------------------------------*/
  Future getSingleCoinExchangeBalanceFromAll(
      String targetCoin, String baseCoin) async {
    log.e('In getSingleCoinExchangeBalanceFromAll');

    targetCoinExchangeBalance =
        await apiService.getSingleCoinExchangeBalance(targetCoin);
    log.i('targetCoin Balance using api ${targetCoinExchangeBalance.toJson()}');

    baseCoinExchangeBalance =
        await apiService.getSingleCoinExchangeBalance(baseCoin);
    log.i('baseCoin Balance using api ${baseCoinExchangeBalance.toJson()}');

    if (targetCoinExchangeBalance == null || baseCoinExchangeBalance == null) {
      String exgAddress = await sharedService.getExgAddressFromWalletDatabase();
      List res = await walletService.getAllExchangeBalances(exgAddress);

      targetCoinExchangeBalance = new ExchangeBalanceModel();
      baseCoinExchangeBalance = new ExchangeBalanceModel();

      res.forEach((coin) {
        if (coin['coin'] == baseCoin) {
          log.w('baseCoin ExchangeBalance $coin');
          baseCoinExchangeBalance.unlockedAmount = coin['amount'];
          baseCoinExchangeBalance.lockedAmount = coin['lockedAmount'];
          print(
              'exchangeBalance using all coins for loop ${baseCoinExchangeBalance.toJson()}');
        }
        // else{
        //     baseCoinExchangeBalance.unlockedAmount = 0.0;
        //   baseCoinExchangeBalance.lockedAmount = 0.0;
        // }
        if (coin['coin'] == targetCoin) {
          log.w('targetCoin ExchangeBalance $coin');
          targetCoinExchangeBalance.unlockedAmount = coin['amount'];
          targetCoinExchangeBalance.lockedAmount = coin['lockedAmount'];
          print(
              'exchangeBalance using all coins for loop ${targetCoinExchangeBalance.toJson()}');
        }
        // else{
        //     targetCoinExchangeBalance.unlockedAmount = 0.0;
        //   targetCoinExchangeBalance.lockedAmount = 0.0;
        // }
      });
    }
    tradeService.setBalanceRefresh(false);
  }

  /*----------------------------------------------------------------------
                        Showcase Feature
----------------------------------------------------------------------*/
  showcaseEvent(BuildContext test) async {
    if (!storageService.isShowCaseView)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(test).startShowCase([globalKeyOne, globalKeyTwo]);
      });
  }

  fillPriceAndQuantityTextFields(p, q) {
    setBusy(true);
    priceTextController.text =
        p.toStringAsFixed(singlePairDecimalConfig.priceDecimal);
    price = p;
    quantityTextController.text =
        q.toStringAsFixed(singlePairDecimalConfig.qtyDecimal);
    quantity = q;
    setBusy(false);
  }

  /*----------------------------------------------------------------------
                        Fill text fields
----------------------------------------------------------------------*/
  initialTextfieldsFill() {
    setBusy(true);
    priceTextController.text =
        orderbook.price.toStringAsFixed(singlePairDecimalConfig.priceDecimal);
    price = orderbook.price;
    quantityTextController.text =
        orderbook.quantity.toStringAsFixed(singlePairDecimalConfig.qtyDecimal);
    quantity = orderbook.quantity;
    setBusy(false);
  }

  // Set default price for kanban gas price and limit
  setDefaultGasPrice() {
    setBusy(true);
    kanbanGasLimitTextController.text =
        environment["chains"]["KANBAN"]["gasLimit"].toString();
    kanbanGasPriceTextController.text =
        environment["chains"]["KANBAN"]["gasPrice"].toString();
    setBusy(false);
  }

/* ---------------------------------------------------
            Full screen Stack loading indicator
--------------------------------------------------- */
  // Split Pair Name
  splitPair(String pair) async {
    setBusy(true);
    log.e('pair $pair');
    var coinsArray = pair.split("/");
    targetCoinName = coinsArray[0];
    baseCoinName = coinsArray[1];
    tickerName = targetCoinName + baseCoinName;
    log.e('tickername $tickerName');
    await getSingleCoinExchangeBalanceFromAll(targetCoinName, baseCoinName);
    setBusy(false);
  }

/* ---------------------------------------------------
            Handle Text Change
--------------------------------------------------- */
  void handleTextChanged(String name, String text) {
    setBusy(true);
    if (name == 'price') {
      try {
        price = double.parse(text);
        log.w('price $price');
        caculateTransactionAmount();
        updateTransFee();
      } catch (e) {
        setBusy(false);
        log.e('Handle text price changed $e');
      }
    }
    if (name == 'quantity') {
      try {
        quantity = double.parse(text);
        log.w('quantity $quantity');
        caculateTransactionAmount();
        updateTransFee();
      } catch (e) {
        setBusy(false);
        log.e('Handle text quantity changed $e');
      }
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                  Get Decimal Pair Configuration
----------------------------------------------------------------------*/
  getDecimalPairConfig() async {
    setBusy(true);
    String currentCoinName = targetCoinName + baseCoinName;
    await sharedService.getSinglePairDecimalConfig(currentCoinName).then((res) {
      log.w('Current coin $currentCoinName in get decimal config $res');
      singlePairDecimalConfig = res;

      log.e('Price and quantity decimal ${singlePairDecimalConfig.toJson()}');
    });
    setBusy(false);
  }

/*---------------------------------------------------
            Full screen Stack loading indicator
--------------------------------------------------- */
  selectBuySellTab(bool value) {
    setBusy(true);
    bidOrAsk = value;
    log.w('bid $bidOrAsk');
    setBusy(false);
  }

/* ---------------------------------------------------
            Retrieve Wallets
--------------------------------------------------- */
  // retrieveWallets() async {
  //   setBusy(true);
  //   await databaseService.getAll().then((walletList) {
  //     walletInfo = walletList;

  //     for (var i = 0; i < walletInfo.length; i++) {
  //       coin = walletInfo[i];
  //       if (coin.tickerName == targetCoinName.toUpperCase()) {
  //         log.e(
  //             'Coin from wallet info ${coin.tickerName} ---  Target coin name $targetCoinName');
  //         targetCoinWalletData = coin;
  //       }
  //       if (coin.tickerName == baseCoinName.toUpperCase()) {
  //         log.e(
  //             'Coin from wallet info ${coin.tickerName} ---  Target coin name $baseCoinName');
  //         baseCoinWalletData = coin;
  //       }
  //       if (coin.tickerName == 'EXG') {
  //         exgAddress = coin.address;
  //         // this.refresh(exgAddress);
  //       }
  //     }
  //     setBusy(false);
  //   }).catchError((error) {
  //     setBusy(false);
  //   });
  // }

/* ---------------------------------------------------
          Generate Order Hash
--------------------------------------------------- */
  generateOrderHash(bidOrAsk, orderType, baseCoin, targetCoin, amount, price,
      timeBeforeExpiration) {
    setBusy(true);
    var randomStr = randomString(32);
    var concatString = [
      bidOrAsk,
      orderType,
      baseCoin,
      targetCoin,
      amount,
      price,
      timeBeforeExpiration,
      randomStr
    ].join('');
    var outputHashData = keccak(stringToUint8List(concatString));

    // if needed convert the output byte array into hex string.
    var output = hex.encode(outputHashData);
    setBusy(false);
    return output;
  }

/* ---------------------------------------------------
            To Big Int
--------------------------------------------------- */
  toBitInt(num) {
    var numString = num.toString();
    var numStringArray = numString.split('.');
    var zeroLength = 18;
    var val = '';
    if (numStringArray != null) {
      val = numStringArray[0];
      if (numStringArray.length == 2) {
        zeroLength -= numStringArray[1].length;
        val += numStringArray[1];
      }
    }

    var valInt = int.parse(val);
    val = valInt.toString();
    for (var i = 0; i < zeroLength; i++) {
      val += '0';
    }

    return val;
  }

/* ---------------------------------------------------
            Tx Hex For Place Order
--------------------------------------------------- */
  txHexforPlaceOrder(seed) async {
    setBusy(true);
    var timeBeforeExpiration = 423434342432;
    var orderType = 1;
    int baseCoin = 0;
    await coinUtils
        .getCoinTypeIdByName(baseCoinName)
        .then((value) => baseCoin = value);
    log.e('basecoin Hex ==' + baseCoin.toRadixString(16));
    int targetCoin = 0;
    await coinUtils
        .getCoinTypeIdByName(targetCoinName)
        .then((value) => targetCoin = value);

    if (!bidOrAsk) {
      var tmp = baseCoin;
      baseCoin = targetCoin;
      targetCoin = tmp;
    }
    // quantity = NumberUtil().roundDownLastDigit(quantity);
    var orderHash = this.generateOrderHash(bidOrAsk, orderType, baseCoin,
        targetCoin, quantity, price, timeBeforeExpiration);

    var qtyBigInt = NumberUtil.toBigInt(quantity);
    // this.toBitInt(quantity);
    var priceBigInt = this.toBitInt(price);

    print('qtyBigInt==' + qtyBigInt);
    print('priceBigInt==' + priceBigInt);

    var abiHex = abiUtils.getCreateOrderFuncABI(
        false,
        bidOrAsk,
        //  orderType,
        coinUtils.convertDecimalToHex(baseCoin),
        coinUtils.convertDecimalToHex(targetCoin),
        qtyBigInt,
        priceBigInt,
        //   timeBeforeExpiration,
        orderHash);

    sliceAbiHex(abiHex);
    log.e('exg addr $exgAddress');

    var nonce = await getNonce(exgAddress);

    var keyPairKanban = getExgKeyPair(seed);
    var exchangilyAddress = await getExchangilyAddress();
    int kanbanGasPrice = int.parse(kanbanGasPriceTextController.text);
    int kanbanGasLimit = int.parse(kanbanGasLimitTextController.text);

    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        exchangilyAddress,
        nonce,
        kanbanGasPrice,
        kanbanGasLimit);
    setBusy(false);
    return txKanbanHex;
  }

/* ---------------------------------------------------
            Update Transfer Fee
--------------------------------------------------- */
  updateTransFee() async {
    setBusy(true);
    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
    if (kanbanGasLimit != null && kanbanPrice != null) {
      var kanbanPriceBig = BigInt.from(kanbanPrice);
      var kanbanGasLimitBig = BigInt.from(kanbanGasLimit);
      var kanbanTransFeeDouble =
          bigNum2Double(kanbanPriceBig * kanbanGasLimitBig);
      kanbanTransFee = kanbanTransFeeDouble;
      log.w('fee $kanbanPrice $kanbanGasLimit $kanbanTransFeeDouble');
    }
    setBusy(false);
  }

/* ---------------------------------------------------
            Calculate Transaction Amount
--------------------------------------------------- */
  caculateTransactionAmount() {
    if (price != null && quantity != null && price >= 0 && quantity >= 0) {
      transactionAmount = quantity * price;
    }
    return transactionAmount;
  }

/* ---------------------------------------------------
            Place Buy/Sell Order
--------------------------------------------------- */
  Future placeBuySellOrder() async {
    setBusy(true);
    isReloadMyOrders = false;
    await _dialogService
        .showDialog(
            title: AppLocalizations.of(context).enterPassword,
            description:
                AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
            buttonTitle: AppLocalizations.of(context).confirm)
        .then((res) async {
      if (res.confirmed) {
        String mnemonic = res.returnedText;
        Uint8List seed = walletService.generateSeed(mnemonic);

        var txHex = await txHexforPlaceOrder(seed);
        log.e('txhex $txHex');
        var resKanban = await sendKanbanRawTransaction(txHex);
        log.e('resKanban $resKanban');
        if (resKanban != null && resKanban['transactionHash'] != null) {
          showSimpleNotification(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).orderCreatedSuccessfully,
                    style: Theme.of(context).textTheme.headline5),
                Text('txid:' + resKanban['transactionHash'],
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
            position: NotificationPosition.bottom,
          );
          // Future.delayed(new Duration(seconds: 2), () {
          //   getSingleCoinExchangeBalanceFromAll(targetCoinName, baseCoinName);
          //   // isReloadMyOrders = true;
          // });
          Timer.periodic(Duration(seconds: 3), (timer) async {
            var res =
                await tradeService.getTxStatus(resKanban["transactionHash"]);
            if (res != null) {
              log.i('RES $res');
              String status = res['status'];
              if (status == '0x1') {
                setBusy(true);
                log.e('isReloadMyOrders $isReloadMyOrders -- isBusy $isBusy');
                isReloadMyOrders = true;
                getSingleCoinExchangeBalanceFromAll(
                    targetCoinName, baseCoinName);
                Future.delayed(new Duration(milliseconds: 500), () {
                  setBusy(true);
                  isReloadMyOrders = false;
                  log.e('isReloadMyOrders $isReloadMyOrders');
                  setBusy(false);
                });
                setBusy(false);
              }
              log.e('isReloadMyOrders $isReloadMyOrders');
              log.i('timer cancelled');
              timer.cancel();
            }
          });
        } else {
          walletService.showInfoFlushbar(
              AppLocalizations.of(context).placeOrderTransactionFailed,
              resKanban.toString(),
              Icons.cancel,
              red,
              context);
        }
      } else if (res.returnedText == 'Closed' && !res.confirmed) {
        log.e('Dialog Closed By User');
        setBusy(false);
      } else {
        log.e('Wrong pass');
        setBusy(false);
        showNotification(context);
      }
    });
    setBusy(false);
  }

/* ---------------------------------------------------
            Check Pass
--------------------------------------------------- */
  checkPass(context) async {
    setBusy(true);

    var targetCoinbalance = targetCoinExchangeBalance.unlockedAmount;

    //targetCoinWalletData.inExchange; // coin(asset) bal for sell
    var baseCoinbalance = baseCoinExchangeBalance.unlockedAmount;
    // baseCoinWalletData.inExchange; // usd bal for buy

    if (price == null ||
        quantity == null ||
        price.isNegative ||
        quantity.isNegative) {
      setBusy(false);
      sharedService.alertDialog("", AppLocalizations.of(context).invalidAmount,
          isWarning: false);
      return;
    }
    if (gasAmount < kanbanTransFee) {
      setBusy(false);
      showSimpleNotification(
        Center(
          child: Text(AppLocalizations.of(context).insufficientGasBalance,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontWeight: FontWeight.w800)),
        ),
        background: sellPrice,
        position: NotificationPosition.bottom,
      );

      return;
    }

    if (!bidOrAsk) {
      log.e('SELL tx amount $quantity -- targetCoinbalance $targetCoinbalance');
      if (quantity > targetCoinbalance) {
        sharedService.alertDialog(
            "", AppLocalizations.of(context).invalidAmount,
            isWarning: false);
        setBusy(false);
        return;
      } else {
        await placeBuySellOrder();
      }
    } else {
      log.w(
          'BUY tx amount ${caculateTransactionAmount()} -- baseCoinbalance $baseCoinbalance');
      if (caculateTransactionAmount() > baseCoinbalance) {
        sharedService.alertDialog(
            "", AppLocalizations.of(context).invalidAmount,
            isWarning: false);
        setBusy(false);
        return;
      } else {
        print('going to place order');
        await placeBuySellOrder();
      }
    }

    /// load orders here after the end of placing order
    /// MyOrdersView(tickerName: tickerName);
    setBusy(false);
  }

/* ---------------------------------------------------
                  Slider Onchange
--------------------------------------------------- */

  sliderOnchange(double newValue) {
    setBusy(true);
    log.i('new slider value $newValue');
    sliderValue = newValue;
    //if (sliderValue == 100) sliderValue = sliderValue - 0.001;
    log.i('sliderValue $sliderValue');
    var targetCoinbalance =
        targetCoinExchangeBalance.unlockedAmount; // usd bal for buy

    //   targetCoinbalance = NumberUtil().roundDownLastDigit(targetCoinbalance);
    //  targetCoinWalletData.inExchange;
    var baseCoinbalance =
        baseCoinExchangeBalance.unlockedAmount; //coin(asset) bal for sell
    //  baseCoinbalance = NumberUtil().roundDownLastDigit(baseCoinbalance);
    //baseCoinWalletData
    //  .inExchange;
    if (quantity.isNaN) quantity = 0.0;
    if (price != null &&
        quantity != null &&
        !price.isNegative &&
        !quantity.isNegative) {
      if (!bidOrAsk) {
        var changeQuantityWithSlider = targetCoinbalance * sliderValue / 100;
        quantity = changeQuantityWithSlider;

        double formattedQuantity = NumberUtil().truncateDoubleWithoutRouding(
            quantity,
            precision: singlePairDecimalConfig.qtyDecimal);
        // double roundedQtyDouble = double.parse(roundedQtyString);
        // roundedQtyDouble = NumberUtil().roundDownLastDigit(roundedQtyDouble);

        transactionAmount = formattedQuantity * price;
        quantityTextController.text = formattedQuantity.toString();
        quantity = formattedQuantity;
        updateTransFee();
        log.i('transactionAmount $transactionAmount');
        log.e('changeQuantityWithSlider $changeQuantityWithSlider');
      } else {
        log.w('base balance $baseCoinbalance');
        var changeBalanceWithSlider = baseCoinbalance * sliderValue / 100;
        quantity = changeBalanceWithSlider / price;
        String roundedQtyString = NumberUtil()
            .truncateDoubleWithoutRouding(quantity,
                precision: singlePairDecimalConfig.qtyDecimal)
            .toString();
        double roundedQtyDouble = double.parse(roundedQtyString);
        roundedQtyDouble = NumberUtil().roundDownLastDigit(roundedQtyDouble);
        transactionAmount = roundedQtyDouble * price;
        quantityTextController.text = roundedQtyDouble.toString();
        quantity = roundedQtyDouble;
        updateTransFee();

        log.i('calculated tx amount $transactionAmount');
        log.e('Balance change with slider $changeBalanceWithSlider');
      }
    } else {
      log.e(
          'In sliderOnchange else where quantity $quantity or price $price is null/empty');
    }
    setBusy(false);
  }

/* ---------------------------------------------------
            Show Notification
--------------------------------------------------- */
  showNotification(context) {
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
  }
}
