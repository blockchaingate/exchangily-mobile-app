import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../shared/globals.dart' as globals;

class WalletSetupScreen extends StatefulWidget {
  const WalletSetupScreen({Key key}) : super(key: key);

  @override
  _WalletSetupScreenState createState() => _WalletSetupScreenState();
}

class _WalletSetupScreenState extends State<WalletSetupScreen> {
  WalletService walletService = locator<WalletService>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkExistingWallet();
  }

  generateMnemonic() {
    walletService.getRandomMnemonic();
  }

  void checkExistingWallet() async {
    final storage = new FlutterSecureStorage();

    //await storage.delete(key: 'wallets');
    await storage.read(key: 'wallets').then((encodedJsonWallets) {
      print('wallet setup $encodedJsonWallets');
      if (encodedJsonWallets == null) {
        print('Generating new mnemonic in wallet setup');
        // generateMnemonic();
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (BuildContext context) => WalletSetupScreen()));
      } else if (encodedJsonWallets.isNotEmpty) {
        Navigator.of(context).pushNamed('/dashboard');
      }
    }).catchError((error) {
      print('No Wallets found in the Storage $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        print('new mnemonic on create wallet button press');
                        // String randomMnemonic = generateMnemonic();
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
    );
  }
}
