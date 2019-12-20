import 'package:encrypt/encrypt.dart' as prefix0;
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/view_models/create_wallet_view_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/api.dart';
import 'package:provider/provider.dart';

class CreateWalletScreen extends StatefulWidget {
  final List<String> mnemonic;
  const CreateWalletScreen({Key key, this.mnemonic}) : super(key: key);

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final log = getLogger('Create Wallet');

  TextEditingController _passTextController = TextEditingController();
  TextEditingController _confirmPassTextController = TextEditingController();
  WalletService walletService = WalletService();

  @override
  void dispose() {
    _passTextController.dispose();
    _confirmPassTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateWalletViewModel>.value(
      value: CreateWalletViewModel(walletService: Provider.of(context)),
      child: Consumer<CreateWalletViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Create Wallet'),
            backgroundColor: globals.secondaryColor,
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Enter password which is minimum 8 characters long and contains at least 1 uppercase, lowercase, number and a special character',
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.left,
                ),
                _buildPasswordTextField(),
                _buildConfirmPasswordTextField(),
                model.busy
                    ? CircularProgressIndicator()
                    : _buildCreateNewWalletButton(model),
                Text(
                  'Note: For Password reset you have Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Password

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passTextController,
      obscureText: true,
      maxLength: 16,
      style: Theme.of(context).textTheme.headline,
      decoration: InputDecoration(
        labelText: 'Enter Password',
        prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
        labelStyle: Theme.of(context).textTheme.headline,
      ),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Confirm Password

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildConfirmPasswordTextField() {
    return TextField(
      controller: _confirmPassTextController,
      obscureText: true,
      maxLength: 16,
      style: TextStyle(fontSize: 15, color: Colors.white),
      decoration: InputDecoration(
          labelText: 'Confirm password',
          prefixIcon: Icon(Icons.lock, color: Colors.white),
          labelStyle: Theme.of(context).textTheme.headline),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Create New Wallet Button

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildCreateNewWalletButton(model) {
    return ButtonTheme(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
      minWidth: double.infinity,
      child: MaterialButton(
        padding: EdgeInsets.all(15),
        color: globals.primaryColor,
        textColor: Colors.white,
        onPressed: () {
          var passSuccess = model.validatePassword(_passTextController.text,
              _confirmPassTextController.text, context);
          if (passSuccess) {
            log.w('in if true');
            model.getBalances(context);
          }
        },
        child: Text(
          'Create New Wallet',
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
