import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:stacked/stacked.dart';

class EventsViewModel extends BaseViewModel {
  final log = getLogger('EventsViewModel');

  final sharedService = locator<SharedService>();
  final storageService = locator<LocalStorageService>();

  String _url = exchangilyAnnouncementUrl;
  String get url => _url;

  updateUrl(String url) async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 50), () => _url = url);
    //+ '${storageService.language}');
    log.w(_url);
    setBusy(false);
  }
}
