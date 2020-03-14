import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';

class CampaignPaymentScreenState extends BaseState {
  final log = getLogger('PaymentScreenState');
  NavigationService _navigationService = locator<NavigationService>();
  String _groupValue;
  get groupValue => _groupValue;
  initState() {
    print('in payment screen');
  }

  radioButtonSelection(value) {
    setState(ViewState.Busy);
    print(value);
    _groupValue = value;
    setState((ViewState.Idle));
  }

  navigateToDashboard() {
    _navigationService.navigateTo('/campaignDashboard');
  }
}
