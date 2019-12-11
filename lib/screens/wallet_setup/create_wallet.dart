import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';

import '../../shared/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateWalletScreen extends StatefulWidget {
  final List<String> mnemonic;
  const CreateWalletScreen({Key key, this.mnemonic}) : super(key: key);

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  TextEditingController _passTextController = TextEditingController();
  TextEditingController _confirmPassTextController = TextEditingController();

  @override
  void dispose() {
    _passTextController.dispose();
    _confirmPassTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Enter password which contains at least 1 uppercase, 1 lowercase, 1 number and 1 special character',
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.left,
            ),
            _buildPasswordTextField(),
            _buildConfirmPasswordTextField(),
            _buildCreateNewWalletButton(),
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
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Password

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passTextController,
      // inputFormatters: <TextInputFormatter>[
      //   WhitelistingTextInputFormatter(RegExp(
      //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
      // ],
      // obscureText: true,
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
      // obscureText: true,
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

  Widget _buildCreateNewWalletButton() {
    return ButtonTheme(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
      minWidth: double.infinity,
      child: MaterialButton(
        padding: EdgeInsets.all(15),
        color: globals.primaryColor,
        textColor: Colors.white,
        onPressed: () {
          validatePassword();
        },
        child: Text(
          'Create New Wallet',
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Check Password

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  checkPassword() {
    if (_passTextController.text != _confirmPassTextController.text) {
      showInfoFlushbar(
          'Password Mismatch',
          'Please retype the same password in both fields',
          Icons.cancel,
          Colors.red);
    } else {
      //Navigator.pushNamed(context, '/balance');
    }
  }

  validatePassword() {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(_passTextController.text);
    if (_passTextController.text.isEmpty) {
      showInfoFlushbar('Empty Password', 'Please fill the password',
          Icons.cancel, Colors.red);
    } else {
      if (!regex.hasMatch(_passTextController.text))
        showInfoFlushbar(
            'Password Conditions Mismatch,',
            'Please enter the password that satisfy above conditions',
            Icons.cancel,
            Colors.red);
      else if (_passTextController.text != _confirmPassTextController.text) {
        showInfoFlushbar(
            'Password Mismatch',
            'Please retype the same password in both fields',
            Icons.cancel,
            Colors.red);
      } else {
        Navigator.pushNamed(context, '/balance');
      }
    }
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Common Flushbar Notification

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  void showInfoFlushbar(
      String title, String message, IconData iconData, Color leftBarColor) {
    Flushbar(
      backgroundColor: globals.secondaryColor.withOpacity(0.75),
      title: title,
      message: message,
      icon: Icon(
        iconData,
        size: 24,
        color: globals.primaryColor,
      ),
      leftBarIndicatorColor: leftBarColor,
      duration: Duration(seconds: 3),
    ).show(context);
  }
}
