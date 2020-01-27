import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class WalletSetupScreen extends StatefulWidget {
  const WalletSetupScreen({Key key}) : super(key: key);

  @override
  _WalletSetupScreenState createState() => _WalletSetupScreenState();
}

class _WalletSetupScreenState extends State<WalletSetupScreen> {
  SharedService sharedService = locator<SharedService>();
  DataBaseService dataBaseService = locator<DataBaseService>();
  final log = getLogger('WalletSetupScreen');
  @override
  void initState() {
    super.initState();
    sharedService.context = context;
    dataBaseService.initDb();
    checkExistingWallet();
  }

  void checkExistingWallet() async {
    dataBaseService.getAll().then((res) {
      if (res == null) {
        log.w('Database is null');
      } else if (res.isNotEmpty) {
        Navigator.of(context).pushNamed('/dashboard');
      }
    }).catchError((error) {
      print('No Wallets found in the Storage $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        log.w('onwillpop');
        sharedService.closeApp();
        return new Future(() => false);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 1,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
        alignment: Alignment.center,
        color: globals.walletCardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Logo Container
            Container(
              height: 50,
              child: Image.asset('assets/images/start-page/logo.png'),
            ),
            Container(
                child: Text(
              AppLocalizations.of(context).welcomeText,
              style: Theme.of(context).textTheme.display2,
            )),
            // Middle Graphics Container
            Container(
              padding: EdgeInsets.all(25),
              child: Image.asset('assets/images/start-page/middle-design.png'),
            ),

            // Button Container
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: RaisedButton(
                        elevation: 5,
                        focusElevation: 5,
                        child: Text(AppLocalizations.of(context).createWallet,
                            style: Theme.of(context).textTheme.display3),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/backupMnemonic');
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      elevation: 5,
                      shape: StadiumBorder(
                          side: BorderSide(color: globals.white, width: 1)),
                      color: globals.secondaryColor,
                      child: Text(
                        AppLocalizations.of(context).importWallet,
                        style: Theme.of(context).textTheme.display3,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/importWallet', arguments: 'import');
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
