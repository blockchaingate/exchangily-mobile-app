import 'package:exchangilymobileapp/services/models.dart';
import 'package:exchangilymobileapp/services/db.dart';
import 'package:exchangilymobileapp/shared/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/globals.dart' as globals;

class Balance extends StatefulWidget {
  const Balance({Key key}) : super(key: key);

  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  DatabaseService walletService = DatabaseService();
  final key = new GlobalKey<ScaffoldState>();
  final double elevation = 5;
  List<WalletInfo> walletInfo;

  @override
  void initState() {
    super.initState();
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Widget Final Named Values

    --------------------------------------------------------------------------------------------------------------------------------------------------------------*/
  Widget build(BuildContext context) {
    /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                 Widget Main Scaffold

    --------------------------------------------------------------------------------------------------------------------------------------------------------------*/
   // return FutureBuilder(
    //  future: walletService.getAllBalances(),
    //  builder: (BuildContext context, AsyncSnapshot snap) {
     //   if (snap.hasData) {
      //    walletInfo = snap.data;
          return Scaffold(
            key: key,
            body: Column(
              children: <Widget>[
                new Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/wallet-page/background.png'),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Image.asset(
                          'assets/images/start-page/logo.png',
                          width: 250,
                          height: 150,
                          color: globals.white,
                        ),
                      ),
                      new Container(
                          padding: EdgeInsets.all(25),
                          margin: EdgeInsets.only(top: 45),
                          child: _totalBalanceCard()),
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _hideSmallAmount(),
                      new ListView.builder(
                        shrinkWrap: true,
                        itemCount: walletInfo.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildListBody(context, index, walletInfo),
                      ),
                    ],
                  ),
                )
              ],
            ),
            bottomNavigationBar: AppBottomNav(),
          );
        }
        // else {
        //   return Scaffold(
        //       body: AlertDialog(
        //     title: Text('No good'),
        //     content: Text('$snap'),
        //   ));
        // }
     // },
  //  );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  All Wallet Addresses in UI

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  addressField(coinName, walletAddress) {
    return TextField(
      onTap: () {
        // copyAddress(walletAddress);
      },
      readOnly: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          filled: true, // Filled needs to be true before fillColor
          // Border gives nice padding as well
          border: OutlineInputBorder(
              borderSide: BorderSide(color: globals.white, width: 2)),
          // Hint Styles
          hintText: walletAddress,
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: globals.primaryColor, // Wallet address color
          ),
          helperText: '$coinName address',
          helperStyle: TextStyle(color: globals.white)),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Card List View

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/
  Widget buildListBody(BuildContext context, int index, List<WalletInfo> info) {
    var name = info[index].name;
    return _coinDetailsCard(
        '$name', info[index].availableBalance, 1000, info[index].usdValue);
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Copy Address Function

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _totalBalanceCard() => Card(
        // margin: EdgeInsets.all(15),
        elevation: elevation,
        color: globals.walletCardColor,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(8),
                decoration: new BoxDecoration(
                    color: globals.iconBackgroundColor,
                    borderRadius: new BorderRadius.circular(50)),
                child: Image.asset(
                  'assets/images/wallet-page/dollar-sign.png',
                  width: 50,
                  height: 50,
                  //  color: globals.white,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total Balance',
                      style: Theme.of(context).textTheme.headline),
                  Text('123456 USD',
                      style: Theme.of(context).textTheme.headline)
                ],
              ),
              Icon(Icons.refresh)
            ],
          ),
        ),
      );

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Hide Small Amount Row

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _hideSmallAmount() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add_alert,
                  semanticLabel: 'Hide Small Amount Assests',
                  color: globals.primaryColor,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Hide Small Amount Assests',
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(wordSpacing: 1.25),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: new BoxDecoration(
                color: globals.primaryColor,
                borderRadius: new BorderRadius.circular(50)),
            child: Icon(
              Icons.add,
              color: globals.white,
            ),
          )
        ],
      );

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Coin Details Wallet Card

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _coinDetailsCard(pairName, available, exgAmount, usdValue) => Card(
        color: globals.walletCardColor,
        elevation: elevation,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('card tapped');
            Navigator.pushNamed(context, '/wallet');
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(8),
                  decoration: new BoxDecoration(
                      color: globals.iconBackgroundColor,
                      borderRadius: new BorderRadius.circular(50),
                      boxShadow: [
                        new BoxShadow(
                            color: globals.iconBackgroundColor,
                            offset: new Offset(1.0, 3.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0),
                      ]),
                  child: Image.asset('assets/images/wallet-page/$pairName.png'),
                  width: 40,
                  height: 40,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$pairName'.toUpperCase(),
                      style: Theme.of(context).textTheme.display1,
                    ),
                    Text('Available',
                        style: Theme.of(context).textTheme.display2),
                    Text('$available', style: TextStyle(color: globals.red))
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(''),
                    Text('Assets in exchange',
                        style: Theme.of(context).textTheme.display2),
                    Text('$exgAmount',
                        style: TextStyle(color: globals.primaryColor))
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(''),
                    Text('Value(USD)',
                        style: Theme.of(context).textTheme.display2),
                    Text('$usdValue', style: TextStyle(color: globals.green))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
} // Wallet Screen State Ends Here
