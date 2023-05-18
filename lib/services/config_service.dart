import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';

class ConfigService {
  LocalStorageService? storageService = locator<LocalStorageService>();

  String? getKanbanBaseUrl() {
    String? baseUrl = environment['endpoints']['kanban'];
    if (storageService!.isHKServer && !storageService!.isUSServer) {
      baseUrl = environment['endpoints']['HKServer'];
    } else if (!storageService!.isHKServer && storageService!.isUSServer) {
      baseUrl = environment['endpoints']['kanban'];
    }
    return baseUrl;
  }

  // String getEthBaseUrl() {
  //   String baseUrl = environment['endpoints']['eth'];
  //   if (storageService.isHKServer && !storageService.isUSServer) {
  //     baseUrl = environment['endpoints']['HKServer'];
  //   } else if (!storageService.isHKServer && storageService.isUSServer) {
  //     baseUrl = environment['endpoints']['eth'];
  //   }
  //   return baseUrl;
  // }

  String? getKanbanBaseWSUrl() {
    String? baseUrl = environment['websocket']['us'];
    if (storageService!.isHKServer && !storageService!.isUSServer) {
      baseUrl = environment['websocket']['hk'];
    } else if (!storageService!.isHKServer && storageService!.isUSServer) {
      baseUrl = environment['websocket']['us'];
    }
    return baseUrl;
  }
}
