import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/wallet_features_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/models/wallet.dart';

class WalletFeaturesScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  WalletFeaturesScreen({Key key, this.walletInfo}) : super(key: key);

  final log = getLogger('WalletFeatures');

  @override
  Widget build(BuildContext context) {
    return BaseScreen<WalletFeaturesScreenState>(
      onModelReady: (model) {
        model.walletInfo = walletInfo;
        model.context = context;
        model.getWalletFeatures();
      },
      builder: (context, model, child) => Scaffold(
        key: key,
        body: ListView(
          children: <Widget>[
            new Container(
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/wallet-page/background.png'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/images/start-page/logo.png',
                      width: 250,
                      height: 60,
                      color: globals.white,
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                      height: 120,
                      alignment: FractionalOffset(0.0, 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Row(
                              children: <Widget>[
                                Text('${walletInfo.tickerName}',
                                    style:
                                        Theme.of(context).textTheme.headline),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 17,
                                  color: globals.white,
                                ),
                                Text('${walletInfo.name}',
                                    style: Theme.of(context).textTheme.headline)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Positioned(
                                  //   bottom: -15,
                                  child: _buildTotalBalanceCard(
                                      context, model, walletInfo),
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
            Container(
              height: 250,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Padding(
                  //     padding: EdgeInsets.all(10),
                  //     child: Text(
                  //       'Receive and Send Exg',
                  //       style: Theme.of(context).textTheme.display3,
                  //     )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: model.containerWidth,
                        height: model.containerHeight,
                        child: _featuresCard(context, 0, model),
                      ),
                      Container(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 1, model))
                    ],
                  ),
                  // Padding(
                  //     padding: EdgeInsets.all(10),
                  //     child: Text(
                  //       'Exchange Exg',
                  //       style: Theme.of(context).textTheme.display3,
                  //     )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 2, model),
                        ),
                        Container(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 3, model),
                        )
                      ])
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Visibility(
                  visible: (walletInfo.tickerName == 'FAB'),
                  child: Container(
                    width: 190,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/smartContract');
                      },
                      child: Text(walletInfo.tickerName + 'Smart Contract',
                          style: TextStyle(fontSize: 15)),
                    ),
                  )),
            )
          ],
        ),
        bottomNavigationBar: AppBottomNav(),
      ),
    );
  }

  // Build Total Balance Card

  Widget _buildTotalBalanceCard(context, model, walletInfo) => Card(
        elevation: model.elevation,
        color: globals.walletCardColor,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '${walletInfo.tickerName} ' +
                        AppLocalizations.of(context).totalBalance,
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 2.0, 0.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: InkWell(
                            onTap: () async {
                              await model.refreshBalance();
                            },
                            child: model.state == ViewState.Busy
                                ? SizedBox(
                                    child: CircularProgressIndicator(),
                                    width: 20,
                                    height: 20,
                                  )
                                : Icon(
                                    Icons.refresh,
                                    color: globals.white,
                                    size: 30,
                                  )),
                      )),
                  Expanded(
                    child: Text(
                      '${model.walletInfo.usdValue} USD',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${walletInfo.tickerName} '.toUpperCase() +
                          AppLocalizations.of(context).walletbalance,
                      style: Theme.of(context).textTheme.headline),
                  Text(AppLocalizations.of(context).assetInExchange,
                      style: Theme.of(context).textTheme.headline)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${model.walletInfo.availableBalance}',
                      style: Theme.of(context).textTheme.headline),
                  Text('${model.walletInfo.assetsInExchange}',
                      style: Theme.of(context).textTheme.headline)
                ],
              )
            ],
          ),
        ),
      );

  // Four Features Card

  Widget _featuresCard(context, index, model) => Card(
        color: globals.walletCardColor,
        elevation: model.elevation,
        child: InkWell(
          splashColor: globals.primaryColor.withAlpha(30),
          onTap: () {
            var route = model.features[index].route;
            Navigator.pushNamed(context, '/$route',
                arguments: model.walletInfo);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: globals.walletCardColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          new BoxShadow(
                              color: model.features[index].shadowColor
                                  .withOpacity(0.5),
                              offset: new Offset(0, 9),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ]),
                    child: Icon(
                      model.features[index].icon,
                      size: 65,
                      color: globals.white,
                    )),
                Text(
                  model.features[index].name,
                  style: Theme.of(context).textTheme.headline,
                )
              ],
            ),
          ),
        ),
      );
}
