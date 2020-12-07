import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarouselWidgetState extends BaseState {
  final log = getLogger('CarouselWidgetState');
  final storageService = locator<LocalStorageService>();

  BuildContext context;

  String lang = '';
  // Init state
  initState() async {
    setBusy(true);
    lang = storageService.language;
    setBusy(false);
  }
}
