import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_v2_model.dart';

class CampaignListDashboardViewModel extends FutureViewModel {
  final log = getLogger('CampaignListDashboardViewModel');
  final apiService = locator<ApiService>();
  final sharedService = locator<SharedService>();
  List<CampaignV2> campaigns = [];
  bool hasParticipated = false;

  @override
  Future futureToRun() {
    return apiService.getCampaignsV2();
  }

  @override
  void onData(data) {
    campaigns = data;
    log.i('campaigns ${campaigns[1].imageUrl}');
  }

  @override
  void onError(error) {
    log.e('error $error');
  }
}
