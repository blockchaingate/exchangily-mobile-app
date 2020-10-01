import 'dart:convert';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/models/alert/alert_response.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/globalLang.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localizations.dart';
import '../../logger.dart';
import '../../service_locator.dart';
import '../base_state.dart';

class AnnouncementListScreenState extends BaseState {
  final log = getLogger('AnnouncementListScreenState');
  // DialogService dialogService = locator<DialogService>();
  // WalletService walletService = locator<WalletService>();
  // WalletDataBaseService walletDatabaseService =
  //     locator<WalletDataBaseService>();
  // SharedService sharedService = locator<SharedService>();
  BuildContext context;
  SharedPreferences prefs;
  List announceList = [];
  init() async {
    setBusy(true);
    prefs = await SharedPreferences.getInstance();
    List tempdata = prefs.getStringList('announceData');
    tempdata.forEach((element) {
      announceList.add(jsonDecode(element));
      print('jsonData $announceList');
    });
    print("announceList from list page state: ");
    print(announceList.toString());
    setBusy(false);
  }

  updateReadStatus(index) {
    setBusy(true);
    log.i("updateReadStatus function: ");
    announceList[index]['isRead'] = true;
    print("announceList[" +
        index.toString() +
        "]['isRead']: " +
        announceList[index]['isRead'].toString());
    //save cache
    List<String> jsonData = [];
    int readedNum = 0;
    announceList.forEach((element) {
      element["isRead"] == false ? readedNum++ : readedNum = readedNum;
      jsonData.add(jsonEncode(element));
      print('jsonData $jsonData');
    });
    setunReadAnnouncement(readedNum);
    print("check status: " + prefs.containsKey('announceData').toString());
    prefs.setStringList('announceData', jsonData);
    //save cache end
    setBusy(false);
  }
}
