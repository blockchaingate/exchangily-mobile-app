import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class CampaignRegisterAccountScreenState extends BaseState {
  final log = getLogger('RegisterScreenState');
  CampaignService? campaignService = locator<CampaignService>();
  NavigationService? navigationService = locator<NavigationService>();
  SharedService? sharedService = locator<SharedService>();

  late BuildContext context;
  late bool passwordMatch;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final referralCodeTextController = TextEditingController();
  final exgWalletAddressTextController = TextEditingController();
  late User user;
  bool isPasswordTextVisible = false;
  CampaignUserData? userData;
  final WalletService? walletService = locator<WalletService>();

  init() async {
    await getExgWalletAddr();
  }

  // Get exg wallet address
  getExgWalletAddr() async {
    exgWalletAddressTextController.text = (await walletService!
        .getAddressFromCoreWalletDatabaseByTickerName('EXG'))!;
    log.w('Exg wallet address ${exgWalletAddressTextController.text}');
  }

  Future<CampaignUserData?> register(User user) async {
    setBusy(true);
    await campaignService!
        .registerAccount(user, referralCodeTextController.text,
            exgWalletAddressTextController.text)
        .then((res) async {
      // String loginToken = res['token'];
      String? error = res['message'];
      if (res != null && (error == null || error == '')) {
        sharedService!.alertDialog(
            FlutterI18n.translate(context, "registrationSuccessful"),
            FlutterI18n.translate(
                context, "pleaseCheckYourEmailToActivateYourAccount"),
            path: '/campaignLogin');
        // await campaignService.saveCampaignUserDataLocally(loginToken, userData);
        // navigationService.navigateTo('/campaignDashboard', arguments: userData);
        setBusy(false);
      } else {
        setErrorMessage(error);
        setBusy(false);
      }
    }).catchError((err) {
      setBusy(false);
      log.e(err);
    });
    return userData;
  }

  // Check fields before calling the api
  checkInputValues() {
    setBusy(true);
    matchPassword();
    if (emailTextController.text.isEmpty) {
      setErrorMessage(
          FlutterI18n.translate(context, "pleaseEnterYourEmailAddress"));
    } else if (passwordTextController.text.isEmpty) {
      setErrorMessage(FlutterI18n.translate(context, "pleaseFillYourPassword"));
    } else if (confirmPasswordTextController.text.isEmpty) {
      setErrorMessage(
          FlutterI18n.translate(context, "confirmPasswordFieldIsEmpty"));
    } else if (exgWalletAddressTextController.text.isEmpty) {
      setErrorMessage(
          FlutterI18n.translate(context, "exgWalletAddressIsRequired"));
    } else if (!passwordMatch) {
      setErrorMessage(
          FlutterI18n.translate(context, "bothPasswordFieldsShouldMatch"));
    } else {
      setErrorMessage('');
      user = User(
          email: emailTextController.text,
          password: passwordTextController.text);
      register(user);
    }
    setBusy(false);
  }

  matchPassword() {
    passwordTextController.text == confirmPasswordTextController.text
        ? passwordMatch = true
        : passwordMatch = false;
  }

  showPasswordText(bool value) {
    setBusy(true);
    isPasswordTextVisible = value;
    setBusy(false);
  }

  // Paste exg address

  pasteClipboardText() async {
    ClipboardData data = (await Clipboard.getData(Clipboard.kTextPlain))!;

    exgWalletAddressTextController.text = data.text!;
  }
}
