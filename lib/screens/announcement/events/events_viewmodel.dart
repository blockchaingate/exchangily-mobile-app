import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:stacked/stacked.dart';

class EventsViewModel extends BaseViewModel {
  final log = getLogger('EventsViewModel');

  final SharedService? sharedService = locator<SharedService>();
  final LocalStorageService? storageService = locator<LocalStorageService>();

  String _url = exchangilyAnnouncementUrl;
  String get url => _url;

  bool _isAnnouncement = true;
  bool get isAnnouncement => _isAnnouncement;
  String? lang = '';
  init() {
    updateLangCode(storageService!.language);
    _url = _url + lang!;
  }

  updateUrl(String passedUrl, {bool isAnnouncement = false}) async {
    setBusy(true);
    lang = storageService!.language;
    _isAnnouncement = isAnnouncement;
    if (isAnnouncement) {
      lang = updateLangCode(lang);
    }
    if (lang == 'en') {
      lang = '';
    }
    _url = passedUrl;
    await Future.delayed(
        const Duration(milliseconds: 50), () => _url = passedUrl + lang!);
    log.i(_url);
    setBusy(false);
  }

  String? updateLangCode(String? langcode) {
    lang = langcode == "en" ? "en" : "sc";
    return lang;
  }
}
