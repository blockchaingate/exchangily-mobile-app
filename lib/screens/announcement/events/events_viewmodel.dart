import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:stacked/stacked.dart';

class EventsViewModel extends BaseViewModel {
  final sharedService = locator<SharedService>();

  String _url = exchangilyAnnouncementUrl;
  String get url => _url;

  updateUrl(String url) async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 50), () => _url = url);

    setBusy(false);
  }
}
