import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';

class ConfigService {
  var storageService = locator<LocalStorageService>();

  String getKanbanBaseUrl() {
    String baseUrl = '';
    if (storageService.isHKServer && !storageService.isUSServer) {
      baseUrl = 'https://api.dscmap.com/';
    } else if (!storageService.isHKServer && storageService.isUSServer) {
      baseUrl = isProduction
          ? 'https://kanbanprod.fabcoinapi.com/'
          : 'https://kanbantest.fabcoinapi.com/';
    }
    return baseUrl;
  }
}
