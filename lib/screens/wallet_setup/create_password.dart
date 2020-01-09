import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/create_password_screen_state.dart';
import '../../shared/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String mnemonic;
  const CreatePasswordScreen({Key key, this.mnemonic}) : super(key: key);

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final log = getLogger('Create Password');
  FocusNode passFocus = FocusNode();
  TextEditingController _passTextController = TextEditingController();
  TextEditingController _confirmPassTextController = TextEditingController();
  WalletService walletService = WalletService();

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CreatePasswordScreenState>(
      onModelReady: (model) {
        model.errorMessage = '';
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).secureYourWallet),
          backgroundColor: globals.secondaryColor,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).setPasswordConditions,
                style: Theme.of(context).textTheme.headline,
                textAlign: TextAlign.left,
              ),
              _buildPasswordTextField(),
              _buildConfirmPasswordTextField(),
              Center(
                  child: Text(model.errorMessage,
                      style: Theme.of(context)
                          .textTheme
                          .display2
                          .copyWith(color: globals.red))),
              Center(
                child: model.state == ViewState.Busy
                    ? CircularProgressIndicator()
                    : _buildCreateNewWalletButton(model, context),
              ),
              Text(
                AppLocalizations.of(context).setPasswordNote,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
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
        focusNode: passFocus,
        autofocus: true,
        controller: _passTextController,
        obscureText: true,
        maxLength: 16,
        style: Theme.of(context).textTheme.headline,
        decoration: InputDecoration(
            labelText: 'Enter Password',
            prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
            labelStyle: Theme.of(context).textTheme.headline,
            helperStyle: Theme.of(context).textTheme.display2));
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
            labelStyle: Theme.of(context).textTheme.headline,
            helperStyle: Theme.of(context).textTheme.display2));
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Create New Wallet Button

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildCreateNewWalletButton(model, BuildContext context) {
    return ButtonTheme(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
      minWidth: double.infinity,
      child: MaterialButton(
        padding: EdgeInsets.all(15),
        color: globals.primaryColor,
        textColor: Colors.white,
        onPressed: () async {
          // Remove the on screen keyboard by shifting focus to unused focus node
          FocusScope.of(context).requestFocus(FocusNode());
          var passSuccess = model.validatePassword(_passTextController.text,
              _confirmPassTextController.text, context, widget.mnemonic);

          _passTextController.text = '';
          _confirmPassTextController.text = '';
          model.errorMessage = '';
          if (passSuccess) {
            List<WalletInfo> _walletInfo = await model.getAllCoins();

            Navigator.pushNamed(context, '/totalBalance',
                arguments: _walletInfo);
          }
        },
        child: Text(
          AppLocalizations.of(context).createWallet,
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
