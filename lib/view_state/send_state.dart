import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/view_state/base_state.dart';

class SendScreenState extends BaseState {
  final log = getLogger('SendState');
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();

  Future checkPass() async {
    log.w('dialog called');
    var res = await _dialogService.showDialog(
        title: 'Enter Password',
        description:
            'Type the same password which you entered while creating the wallet');
    if (res.confirmed) {
      log.w('User has confirmed');
    } else {
      log.w('User cancelled the dialog');
    }
    log.w('dialog closed');
  }
}
