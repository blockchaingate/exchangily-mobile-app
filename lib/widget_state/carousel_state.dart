import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarouselWidgetState extends BaseState {
  final log = getLogger('CarouselWidgetState');
 

  BuildContext context;

  String lang = '';
  // Init state
  initState() async {
    setBusy(true);
    log.e(busy);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');

    setBusy(false);
  }
}
