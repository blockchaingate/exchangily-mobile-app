import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_v2/campaign_v2_model.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';

class CampaignListDashboardViewModel extends FutureViewModel {
  final log = getLogger('CampaignListDashboardViewModel');
  final apiService = locator<ApiService>();
  final sharedService = locator<SharedService>();
  final walletDatabaseService = locator<WalletDataBaseService>();
  List<CampaignV2> campaigns = [];
  @override
  Future futureToRun() {
    return apiService.getCampaignsV2();
  }

  @override
  void onData(data) async {
    campaigns = data;
    log.i('campaigns ${campaigns[1].imageUrl}');

    await checkCampaignEntryStatus();

    log.i('campaign entry ${campaigns[1].hasJoined}');
  }

  checkCampaignEntryStatus() async {
    setBusy(true);
    String exgAddress = '';
    await walletDatabaseService
        .getBytickerName('EXG')
        .then((res) => exgAddress = res.address);
    campaigns.forEach((campaign) async {
      await apiService
          .getCampaignsEntryStatus(campaign.id, exgAddress)
          .then((res) {
        log.w('checkCampaignEntryStatus res $res');
        setBusy(true);
        if (res != null) {
          campaign.hasJoined = true;
        }
        hasParticipationChecked = true;
        setBusy(false);
      });
    });
  }

  placeOrder(int campaignId) {}

  @override
  void onError(error) {
    log.e('error $error');
  }
}
