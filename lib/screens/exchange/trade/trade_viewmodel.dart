import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/decimal_config.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/market_trades/market_trade_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/stoppable_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:keccak/keccak.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:random_string/random_string.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:hex/hex.dart';
import 'package:convert/convert.dart';

class TradeViewModel extends MultipleStreamViewModel with StoppableService {
  final Price pairPriceByRoute;
  TradeViewModel({this.pairPriceByRoute});

  final log = getLogger('TradeViewModal');

  BuildContext context;

  DialogService dialogService = locator<DialogService>();
  var storageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  ApiService apiService = locator<ApiService>();
  TradeService _tradeService = locator<TradeService>();
  WalletService walletService = locator<WalletService>();
  ConfigService configService = locator<ConfigService>();
  List<PairDecimalConfig> pairDecimalConfigList = [];

  //List<Order> buyOrderBookList = [];
  //List<Order> sellOrderBookList = [];
  Orderbook orderbook = new Orderbook();

  List<MarketTrades> marketTradesList = [];

  // List<Order> myOrders = [];

  Price currentPairPrice = new Price();
  List<dynamic> ordersViewTabBody = [];

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  String tickerStreamKey = 'ticker';
  String marketTradesStreamKey = 'marketTradesList';
  String orderbookStreamKey = 'orderbook';

  //List myExchangeAssets = [];
  DecimalConfig singlePairDecimalConfig = new DecimalConfig();
  bool isDisposing = false;
  double usdValue = 0.0;
  String pairSymbolWithSlash = '';
  String get interval => _tradeService.interval;

  WebViewController webViewController;
  bool isStreamDataNull = false;

/* ---------------------------------------------------
                Buy/Sell Variables
--------------------------------------------------- */
  List<WalletInfo> walletInfo;
  WalletInfo targetCoinWalletData;
  WalletInfo baseCoinWalletData;

  WalletDataBaseService databaseService = locator<WalletDataBaseService>();

  bool bidOrAsk;
  String baseCoinName;
  String targetCoinName;

  TextEditingController kanbanGasPriceTextController = TextEditingController();
  TextEditingController kanbanGasLimitTextController = TextEditingController();
  TextEditingController quantityTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();

  double kanbanTransFee = 0.0;
  bool transFeeAdvance = false;

  List<OrderModel> sell;
  List<OrderModel> buy;
  double currentPrice = 0;
  double currentQuantity = 0;
  double sliderValue = 10.0;
  double price = 0.0;
  double quantity;

  String exgAddress;
  WalletInfo coin;

  List<OrderModel> orderList;
  double transactionAmount = 0;
  int priceDecimal = 0;
  int quantityDecimal = 0;
  String pair = '';
  String tickerName = '';

  //Price passedPair;
  GlobalKey globalKeyOne;
  GlobalKey globalKeyTwo;
  double unlockedAmount;
  double lockedAmount;
  ExchangeBalanceModel targetCoinExchangeBalance;
  ExchangeBalanceModel baseCoinExchangeBalance;
  bool isReloadMyOrders = false;

/* ---------------------------------------------------
                Streams
--------------------------------------------------- */
  @override
  Map<String, StreamData> get streamsMap => {
        tickerStreamKey: StreamData<dynamic>(
            _tradeService.getTickerDataStream(pairPriceByRoute.symbol)),
        marketTradesStreamKey: StreamData<dynamic>(_tradeService
            .getMarketTradesStreamByTickerName(pairPriceByRoute.symbol)),
        orderbookStreamKey: StreamData<dynamic>(_tradeService
            .getOrderBookStreamByTickerName(pairPriceByRoute.symbol))
      };
  // Map<String, StreamData> res =
  //     tradeService.getMultipleStreams(pairPriceByRoute.symbol);

  /// Initialize when model ready
  init() async {
    await getDecimalPairConfig();
    String holder = updateTickerName(pairPriceByRoute.symbol);
    pairSymbolWithSlash = holder;
    if (pairSymbolWithSlash.split('/')[1] == 'USDT' ||
        pairSymbolWithSlash.split('/')[1] == 'DUSD') {
      usdValue = dataReady('allPrices')
          ? currentPairPrice.price
          : pairPriceByRoute.price;
    } else {
      String tickerWithoutBasePair = pairSymbolWithSlash.split('/')[0];
      usdValue = await apiService
          .getCoinMarketPriceByTickerName(tickerWithoutBasePair);
    }
  }

  @override
  void onSubscribed(String key) {
    log.w('$key Stream subscribed ');
  }

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) async {
    log.w('key $key -- data $data');
  }

/*----------------------------------------------------------------------
          Transform stream data before notifying to view modal
----------------------------------------------------------------------*/

  @override
  dynamic transformData(String key, dynamic data) {
    log.w('transformData key $key  -- data $data');
    try {
      /// Ticker WS
      if (key == tickerStreamKey) {
        if (data != null && data != []) {
          var jsonDynamic = jsonDecode(data);
          // log.i('ticker json data $jsonDynamic');
          currentPairPrice = Price.fromJson(jsonDynamic);
        } else {
          log.i('$key Data is null or empty');
        }
        // log.w('TICKER PRICE ${currentPairPrice.toJson()}');

      }
/*----------------------------------------------------------------------
                    Market trade list
----------------------------------------------------------------------*/

      else if (key == marketTradesStreamKey) {
        if (data != null && data != []) {
          List<dynamic> jsonDynamicList = jsonDecode(data) as List;
          MarketTradeList tradeList = MarketTradeList.fromJson(jsonDynamicList);
          marketTradesList = tradeList.trades;
        } else {
          log.i('$key Data is null or empty');
        }
      }

/*----------------------------------------------------------------------
                    Orderbook
----------------------------------------------------------------------*/

      else if (key == orderbookStreamKey) {
        var jsonDynamic = jsonDecode(data);
        Orderbook orderbook = Orderbook.fromJson(jsonDynamic);
        orderbook = orderbook;
      } else {
        log.i('$key Data is null or empty');
      }
    } catch (err) {
      log.e('Catch error $err');
      //   setBusy(true);
      //  isStreamDataNull = true;
      //   closeConnections();
      setBusy(false);
    }
  }

/*----------------------------------------------------------------------
                onError
----------------------------------------------------------------------*/
  @override
  void onError(String key, error) {
    log.e('In onError $key $error');
    // getSubscriptionForKey(key).cancel();
    // getSubscriptionForKey(key).resume();
  }

/*----------------------------------------------------------------------
                  On Cancel gets called while disposing
----------------------------------------------------------------------*/
  @override
  void onCancel(String key) {
    log.e('Stream $key closed');
    if (key == tickerStreamKey) {
      _tradeService
          .tickerDataChannel(pairPriceByRoute.symbol)
          .sink
          .close()
          .then((value) => log.i('tickerDataChannel closed'));
    }
    if (key == marketTradesStreamKey) {
      _tradeService
          .marketTradesChannel(pairPriceByRoute.symbol)
          .sink
          .close()
          .then((value) => log.i('marketTradesChannel closed'));
    }
    if (key == orderbookStreamKey) {
      _tradeService
          .ordersbookChannel(pairPriceByRoute.symbol)
          .sink
          .close()
          .then((value) => log.i('Orderbook channel closed'));
    }
  }

/*----------------------------------------------------------------------
                  Order aggregation
----------------------------------------------------------------------*/

  List<Orderbook> orderAggregation(List<Orderbook> passedOrders) {
    List<Orderbook> result = [];
    print('passed orders length ${passedOrders.length}');
    double prevQuantity = 0.0;
    List<int> indexArray = [];
    double prevPrice = 0;

    // for each
    passedOrders.forEach((currentOrder) {
      print('single order ${currentOrder.toJson()}');
      int index = 0;
      double aggrQty = 0;
      index = passedOrders.indexOf(currentOrder);
      if (currentOrder.price == prevPrice) {
        log.i(
            'price matched with prev price ${currentOrder.price} -- $prevPrice');
        log.w(
            ' currentOrder qty ${currentOrder.quantity} -- prevQuantity $prevQuantity');
        currentOrder.quantity += prevQuantity;
        //  aggrQty = currentOrder.orderQuantity + prevQuantity;
        prevPrice = currentOrder.price;
        log.e(' currentOrder.orderQuantity  ${currentOrder.quantity}');
        indexArray.add(passedOrders.indexOf(currentOrder));
        result.removeWhere((order) => order.price == prevPrice);
        result.add(currentOrder);
      } else {
        prevPrice = currentOrder.price;
        prevQuantity = currentOrder.quantity;
        log.w('price NOT matched so prevprice: $prevPrice');
        result.add(currentOrder);
      }
    });
    return result;
  }

/*----------------------------------------------------------------------
                  Get Decimal Pair Configuration
----------------------------------------------------------------------*/

  getDecimalPairConfig() async {
    await _tradeService
        .getSinglePairDecimalConfig(pairPriceByRoute.symbol)
        .then((decimalValues) {
      singlePairDecimalConfig = decimalValues;
      log.i(
          'decimal values, quantity: ${singlePairDecimalConfig.quantityDecimal} -- price: ${singlePairDecimalConfig.priceDecimal}');
    }).catchError((err) {
      log.e('getDecimalPairConfig $err');
    });
  }

  /// Bottom sheet to show market pair price
  // showBottomSheet() {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.white,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //             width: 200,
  //             height: MediaQuery.of(context).size.height - 50,
  //             child:
  //                 MarketPairsTabView(marketPairsTabBarView: marketPairsTabBar));
  //       });
  // }

  /// Switch Streams
  void switchStreams(int index) async {
    print('Pause/Resume streams $index');

    if (index == 0) {
      pauseStream(marketTradesStreamKey);
      //  getSubscriptionForKey(orderBookStreamKey).resume();
      notifyListeners();
    } else if (index == 1) {
      //  pauseStream(orderBookStreamKey);
      getSubscriptionForKey(marketTradesStreamKey).resume();
      notifyListeners();
    } else if (index == 2) {
      pauseAllStreams();
    } else if (index == 3) {
      pauseAllStreams();
      // await getExchangeAssets();
    }
  }

  pauseAllStreams() {
    log.e('Stream pause');
    getSubscriptionForKey(marketTradesStreamKey).pause();
    // getSubscriptionForKey(orderBookStreamKey).pause();
    notifyListeners();
  }

  resumeAllStreams() {
    log.e('Stream resume');

    getSubscriptionForKey('marketTradesList').resume();
    getSubscriptionForKey('orderBookList').resume();
    notifyListeners();
  }

  pauseStream(String key) {
    // If the subscription is paused more than once,
    // an equal number of resumes must be performed to resume the stream
    log.e(getSubscriptionForKey(key).isPaused);
    if (!getSubscriptionForKey(key).isPaused)
      getSubscriptionForKey(key).pause();
    log.i(getSubscriptionForKey(key).isPaused);
  }

  void cancelSingleStreamByKey(String key) {
    var stream = getSubscriptionForKey(key);
    stream.cancel();
    log.e('Stream $key cancelled');
  }

  String updateTickerName(String tickerName) {
    return _tradeService.seperateBasePair(tickerName);
  }

  // getMyOrders() async {
  //   setBusy(true);
  //   String exgAddress = await getExgAddress();
  //   myOrders = await tradeService.getMyOrders(exgAddress);
  //   setBusy(false);
  //   log.w('My orders $myOrders');
  // }

/*-------------------------------------------------------------------------------------
                                Get Exchange Assets
-------------------------------------------------------------------------------------*/

  Future<String> getExgAddress() async {
    var exgWallet = await walletDataBaseService.getBytickerName('EXG');
    return exgWallet.address;
  }

  onBackButtonPressed() {
    navigationService.navigateUsingPushReplacementNamed(MarketsViewRoute,
        arguments: false);
  }

/*-------------------------------------------------------------------------------------
                                Buy/Sel Viewmodel functions
-------------------------------------------------------------------------------------*/

  buySellInit() async {
    setBusy(true);
    setDefaultGasPrice();
    sharedService.context = context;

    exgAddress = await sharedService.getExgAddressFromWalletDatabase();

    transFeeAdvance = false;
    splitPair(pairSymbolWithSlash);
    setBusy(false);
  }

/*----------------------------------------------------------------------
                Single coin exchange balance using old api
----------------------------------------------------------------------*/
  Future getSingleCoinExchangeBalanceFromAll(
      String targetCoin, String baseCoin) async {
    setBusy(true);
    log.e('In get exchange assets');

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
    setBusy(false);
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

/* ---------------------------------------------------
            selectBuySellTab
--------------------------------------------------- */
  selectBuySellTab(bool value) {
    setBusy(true);
    bidOrAsk = value;
    log.w('bid $bidOrAsk');
    setBusy(false);
  }

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
    await getCoinTypeIdByName(baseCoinName).then((value) => baseCoin = value);
    log.e('basecoin Hex ==' + baseCoin.toRadixString(16));
    int targetCoin = 0;
    await getCoinTypeIdByName(targetCoinName)
        .then((value) => targetCoin = value);

    if (!bidOrAsk) {
      var tmp = baseCoin;
      baseCoin = targetCoin;
      targetCoin = tmp;
    }

    var orderHash = this.generateOrderHash(bidOrAsk, orderType, baseCoin,
        targetCoin, quantity, price, timeBeforeExpiration);

    var qtyBigInt = this.toBitInt(quantity);
    var priceBigInt = this.toBitInt(price);

    print('qtyBigInt==' + qtyBigInt);
    print('priceBigInt==' + priceBigInt);

    var abiHex = getCreateOrderFuncABI(
        false,
        bidOrAsk,
        //  orderType,
        convertDecimalToHex(baseCoin),
        convertDecimalToHex(targetCoin),
        qtyBigInt,
        priceBigInt,
        //   timeBeforeExpiration,
        orderHash);
    debugPrint('abiHex $abiHex');
    sliceAbiHex(abiHex);
    log.e('exg addr $exgAddress');

    var nonce = await getNonce(exgAddress);

    var keyPairKanban = getExgKeyPair(seed);
    var exchangilyAddress = await getExchangilyAddress();
    int kanbanGasPrice = int.parse(kanbanGasPriceTextController.text);
    int kanbanGasLimit = int.parse(kanbanGasLimitTextController.text);

    var txKanbanHex = await signAbiHexWithPrivateKey(
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
    var res = await dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
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
              await _tradeService.getTxStatus(resKanban["transactionHash"]);
          if (res != null) {
            log.i('RES $res');
            String status = res['status'];
            if (status == '0x1') {
              setBusy(true);
              log.e('isReloadMyOrders $isReloadMyOrders -- isBusy $isBusy');
              isReloadMyOrders = true;
              getSingleCoinExchangeBalanceFromAll(targetCoinName, baseCoinName);
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
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
        setBusy(false);
      }
    }
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
  sliderOnchange(newValue) {
    setBusy(true);
    sliderValue = newValue;
    var targetCoinbalance =
        targetCoinExchangeBalance.unlockedAmount; // usd bal for buy
    //  targetCoinWalletData.inExchange;
    var baseCoinbalance =
        baseCoinExchangeBalance.unlockedAmount; //coin(asset) bal for sell
    //baseCoinWalletData
    //  .inExchange;
    if (quantity.isNaN) quantity = 0.0;
    if (price != null &&
        quantity != null &&
        !price.isNegative &&
        !quantity.isNegative) {
      if (!bidOrAsk) {
        var changeQuantityWithSlider = targetCoinbalance * sliderValue / 100;
        print('changeQuantityWithSlider $changeQuantityWithSlider');
        quantity = changeQuantityWithSlider;
        transactionAmount = quantity * price;
        quantityTextController.text = quantity.toStringAsFixed(quantityDecimal);
        updateTransFee();
        log.i(transactionAmount);
        log.e(changeQuantityWithSlider);
      } else {
        var changeBalanceWithSlider = baseCoinbalance * sliderValue / 100;
        quantity = changeBalanceWithSlider / price;
        transactionAmount = quantity * price;
        quantityTextController.text = quantity.toStringAsFixed(quantityDecimal);
        updateTransFee();
        log.w('Slider value $sliderValue');
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
        red,
        context);
  }
}
