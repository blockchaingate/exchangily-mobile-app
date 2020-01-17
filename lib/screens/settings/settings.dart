import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../localizations.dart';
import '../../shared/globals.dart' as globals;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isVisible;
  @override
  void initState() {
    super.initState();
    _isVisible = false;
  }

  void showMnemonic() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    String mnemonic = Provider.of<String>(context);
    final WalletService walletService = locator<WalletService>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).settings),
        backgroundColor: globals.secondaryColor,
      ),
      body: Container(
        // width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InkWell(
                splashColor: globals.primaryColor,
                child: Card(
                  elevation: 4,
                  child: Container(
                    color: globals.walletCardColor,
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).deleteWallet,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.display3,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  await walletService.deleteEncryptedData();
                  final storage = new FlutterSecureStorage();
                  await storage.delete(key: 'wallets');
                  Navigator.pushNamed(context, '/walletSetup');
                },
              ),
              InkWell(
                splashColor: globals.primaryColor,
                child: Card(
                  elevation: 5,
                  child: Container(
                    color: globals.walletCardColor,
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        !_isVisible
                            ? AppLocalizations.of(context).displayMnemonic
                            : AppLocalizations.of(context).hideMnemonic,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.display3,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  showMnemonic();
                  print('mnemonic - $mnemonic - $showMnemonic');
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  !_isVisible ? '' : mnemonic,
                  style: Theme.of(context).textTheme.headline,
                )),
              )
            ]),
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }
}
