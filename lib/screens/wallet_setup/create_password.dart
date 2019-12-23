import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/view_state/create_password_view_state.dart';
import '../../shared/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePasswordScreen extends StatefulWidget {
  final List<String> mnemonic;
  const CreatePasswordScreen({Key key, this.mnemonic}) : super(key: key);

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final log = getLogger('Create Password');

  TextEditingController _passTextController = TextEditingController();
  TextEditingController _confirmPassTextController = TextEditingController();
  WalletService walletService = WalletService();

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CreatePasswordScreenState>(
      // onModelReady: (model) {
      //   log.w('message $model');
      // },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Secure Wallet With The Password'),
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
              Center(
                child: model.state == ViewState.Busy
                    //  model.busy
                    ? CircularProgressIndicator()
                    : _buildCreateNewWalletButton(model),
              ),
              Text(
                'Note: For Password reset you have to keep the mnemonic safe as that is the only way to recover the wallet',
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
        onPressed: () async {
          var passSuccess = model.validatePassword(_passTextController.text,
              _confirmPassTextController.text, context);
          log.w('pass success $passSuccess');
          if (passSuccess) {
            log.w('in if true');
            var _walletInfo = await model.getAllCoins();
            if (_walletInfo == null) {
              log.w('Navigating back to previous page as wallet info is null');
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, '/totalBalance',
                  arguments: _walletInfo);
            }
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
