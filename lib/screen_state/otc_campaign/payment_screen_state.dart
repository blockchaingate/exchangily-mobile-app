import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';

class CampaignPaymentScreenState extends BaseState {
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
}
