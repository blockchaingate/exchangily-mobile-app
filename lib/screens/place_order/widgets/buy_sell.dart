import 'package:random_string/random_string.dart';
import "package:flutter/material.dart";
import "./textfield_text.dart";
import "./order_detail.dart";
import "./my_orders.dart";
import 'package:web_socket_channel/io.dart';
import '../../../services/trade_service.dart';
import '../../../utils/decoder.dart';
import '../../../models/orders.dart';
import '../../../models/order-model.dart';
import '../../../models/trade-model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'dart:typed_data';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:keccak/keccak.dart';
import '../../../utils/string_util.dart';
import 'package:convert/convert.dart';
import '../../../utils/kanban.util.dart';
import 'package:hex/hex.dart';
import '../../../utils/abi_util.dart';
import '../../../utils/keypair_util.dart';
import 'package:exchangilymobileapp/localizations.dart';

class BuySell extends StatefulWidget {
  BuySell({Key key, this.bidOrAsk, this.baseCoinName, this.targetCoinName})
      : super(key: key);
  final bool bidOrAsk;
  final String baseCoinName;
  final String targetCoinName;
  @override
  _BuySellState createState() => _BuySellState();
}

class _BuySellState extends State<BuySell>
    with SingleTickerProviderStateMixin, TradeService {
  bool bidOrAsk;

  List<OrderModel> sell;
  List<OrderModel> buy;
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  double currentPrice = 0;
  double currentQuantity = 0;
  double _sliderValue = 10.0;
  IOWebSocketChannel orderListChannel;
  IOWebSocketChannel tradeListChannel;
  List<WalletInfo> walletInfo;
  double price;
  double quantity;
  String exgAddress;
  final GlobalKey<MyOrdersState> _myordersState =
      new GlobalKey<MyOrdersState>();

  final log = getLogger('BuySell');
  final storage = new FlutterSecureStorage();

  retrieveWallets() async {
    await storage.read(key: 'wallets').then((encodedJsonWallets) async {
      print('there we go');
      final decodedWallets = jsonDecode(encodedJsonWallets);
      print(decodedWallets);
      WalletInfoList walletInfoList = WalletInfoList.fromJson(decodedWallets);
      print(walletInfoList.wallets[0].usdValue);

      walletInfo = walletInfoList.wallets;

      for (var i = 0; i < walletInfo.length; i++) {
        var coin = walletInfo[i];
        if (coin.tickerName == 'EXG') {
          exgAddress = coin.address;
          _myordersState.currentState.refresh(exgAddress);
          break;
        }
      }
    }).catchError((error) {});
  }

  generateOrderHash(bidOrAsk, orderType, baseCoin, targetCoin, amount, price,
      timeBeforeExpiration) {
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
    return output;
  }

  txHexforPlaceOrder(seed) async {
    var timeBeforeExpiration = 423434342432;
    var orderType = 1;
    var baseCoin = walletService.getCoinTypeIdByName(widget.baseCoinName);
    var targetCoin = walletService.getCoinTypeIdByName(widget.targetCoinName);
    var orderHash = this.generateOrderHash(bidOrAsk, orderType, baseCoin,
        targetCoin, quantity, price, timeBeforeExpiration);

    var qtyBigInt = BigInt.from(quantity * 1e18);
    var priceBigInt = BigInt.from(price * 1e18);

    var abiHex = getCreateOrderFuncABI(
        bidOrAsk,
        orderType,
        baseCoin,
        targetCoin,
        qtyBigInt,
        priceBigInt,
        timeBeforeExpiration,
        false,
        orderHash);
    var nonce = await getNonce(exgAddress);
    print('exgAddress===');
    print(exgAddress);
    print('nonce===');
    print(nonce);
    print('abiHex there ou go' + abiHex);
    var keyPairKanban = getExgKeyPair(seed);
    var exchangilyAddress = await getExchangilyAddress();
    var txKanbanHex = await signAbiHexWithPrivateKey(abiHex,
        HEX.encode(keyPairKanban["privateKey"]), exchangilyAddress, nonce);
    return txKanbanHex;
  }

  @override
  void initState() {
    super.initState();
    this.sell = [];
    this.buy = [];
    bidOrAsk = widget.bidOrAsk;
    orderListChannel =
        getOrderListChannel(widget.targetCoinName + widget.baseCoinName);
    orderListChannel.stream.listen((ordersString) {
      Orders orders = Decoder.fromOrdersJsonArray(ordersString);
      _showOrders(orders);
    });

    tradeListChannel =
        getTradeListChannel(widget.targetCoinName + widget.baseCoinName);
    tradeListChannel.stream.listen((tradesString) {
      //print('trades=');
      //print(trades);
      List<TradeModel> trades = Decoder.fromTradesJsonArray(tradesString);

      if (trades != null && trades.length > 0) {
        TradeModel latestTrade = trades[0];

        if (this.mounted) {
          setState(() => {this.currentPrice = latestTrade.price});
        }
      }
    });
    retrieveWallets();
  }

  _showOrders(Orders orders) {
    if (!listEquals(orders.buy, this.buy) ||
        !listEquals(orders.sell, this.sell)) {
      if (this.mounted) {
        setState(() => {
              this.sell = (orders.sell.length > 5)
                  ? (orders.sell.sublist(orders.sell.length - 5))
                  : orders.sell,
              this.buy = (orders.buy.length > 5)
                  ? (orders.buy.sublist(0, 5))
                  : orders.buy
            });
      }
    }
  }

  @override
  void dispose() {
    orderListChannel.sink.close();
    super.dispose();
  }

  placeOrder() {
    checkPass(context);
  }

  void handleTextChanged(String name, String text) {
    print('name=' + name);
    print('text=' + text);
    if (name == 'price') {
      try {
        this.price = double.parse(text);
      } catch (e) {}
    }
    if (name == 'quantity') {
      try {
        this.quantity = double.parse(text);
      } catch (e) {}
    }
  }

  checkPass(context) async {
    print('checkPass begin');
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.fieldOne;
      Uint8List seed = walletService.generateSeed(mnemonic);
      print('seed=');
      print(seed);
      var txHex = await txHexforPlaceOrder(seed);
      var resKanban = await sendKanbanRawTransaction(txHex);
      print('resKanban111=');
      print(resKanban);
    } else {
      if (res.fieldOne != 'Closed') {
        showNotification(context);
      }
    }
  }

  showNotification(context) {
    walletService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: bidOrAsk
                        ? BorderSide(width: 2.0, color: Color(0XFF871fff))
                        : BorderSide.none),
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      bidOrAsk = true;
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context).buy,
                    style: new TextStyle(
                        color: bidOrAsk ? Color(0XFF871fff) : Colors.white,
                        fontSize: 18.0),
                  ))),
          Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: bidOrAsk
                        ? BorderSide.none
                        : BorderSide(width: 2.0, color: Color(0XFF871fff))),
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      bidOrAsk = false;
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context).sell,
                    style: new TextStyle(
                        color: bidOrAsk ? Colors.white : Color(0XFF871fff),
                        fontSize: 18.0),
                  )))
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: Color(0xFF2c2c4c),
          border: Border(
              top: BorderSide(width: 1.0, color: Colors.white10),
              bottom: BorderSide(width: 1.0, color: Colors.white10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: TextfieldText(
                          "price",
                          AppLocalizations.of(context).price,
                          widget.baseCoinName,
                          handleTextChanged),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                      child: TextfieldText(
                          "quantity",
                          AppLocalizations.of(context).quantity,
                          "",
                          handleTextChanged),
                    ),
                    Slider(
                      activeColor: Colors.indigoAccent,
                      min: 0.0,
                      max: 15.0,
                      onChanged: (newRating) {
                        setState(() => _sliderValue = newRating);
                      },
                      value: _sliderValue,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).transactionAmount,
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 14.0),
                            ),
                            Text("1000" + " " + widget.baseCoinName,
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 14.0))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(AppLocalizations.of(context).totalBalance,
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 14.0)),
                            Text("0.0000" + " " + widget.baseCoinName,
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 14.0))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: new SizedBox(
                            width: double.infinity,
                            child: new RaisedButton(
                              padding: const EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              color: bidOrAsk
                                  ? Color(0xFF0da88b)
                                  : Color(0xFFe2103c),
                              onPressed: () => {this.placeOrder()},
                              child: new Text(
                                  bidOrAsk
                                      ? AppLocalizations.of(context).buy
                                      : AppLocalizations.of(context).sell,
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 18.0)),
                            )))
                  ],
                )),
            Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                ),
                                child: Text(AppLocalizations.of(context).price,
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 16.0))),
                            Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                ),
                                child: Text(
                                    AppLocalizations.of(context).quantity,
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 16.0)))
                          ],
                        ),
                        OrderDetail(sell, false),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: Text(currentPrice.toString(),
                                        style: new TextStyle(
                                            color: Color(0xFF17a2b8),
                                            fontSize: 18.0)))
                              ],
                            )),
                        OrderDetail(buy, true)
                      ],
                    )))
          ],
        ),
      ),
      MyOrders(key: _myordersState)
    ]);
  }
}
