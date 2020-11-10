import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';

class ConfigService {
  var storageService = locator<LocalStorageService>();

  String getKanbanBaseUrl() {
    String baseUrl = '';
    if (storageService.isHKServer && !storageService.isUSServer) {
      baseUrl = environment['endpoints']['HKServer'];
    } else if (!storageService.isHKServer && storageService.isUSServer) {
      baseUrl = environment['endpoints']['kanban'];
    }
    return baseUrl;
  }

  String getKanbanBaseWSUrl() {
    String baseUrl = '';
    if (storageService.isHKServer && !storageService.isUSServer) {
      baseUrl = environment['websocket']['hk'];
    } else if (!storageService.isHKServer && storageService.isUSServer) {
      baseUrl = environment['websocket']['us'];
    }
    return baseUrl;
  }
}
