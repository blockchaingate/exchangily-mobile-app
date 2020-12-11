import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:stacked/stacked.dart';

class CarouselViewmodel extends FutureViewModel {
  ApiService apiService = locator<ApiService>();
  LocalStorageService localStorageService = locator<LocalStorageService>();
  SharedService sharedService = locator<SharedService>();
  final log = getLogger('CarouselViewmodel');

  List images;
  String lang = 'en';
  final List imagesLocal = [
    {
      "url": "assets/images/slider/campaign2.jpg",
      "urlzh": "assets/images/slider/adv2.jpg.jpg",
      "route": ''
    },
  ];

  @override
  Future futureToRun() => apiService.getSliderImages();

/*----------------------------------------------------------------------
                  After Future Data is ready
----------------------------------------------------------------------*/
  @override
  void onData(data) {
    if (data == "error") {
      images = imagesLocal;
      log.e('Using local images');
    } else {
      images = data;
      log.e('Using api image data');
      // log.w("Slider from api: $data");
    }
  }

  init() async {
    setBusy(true);
    lang = localStorageService.language;
    setBusy(false);
  }
}
