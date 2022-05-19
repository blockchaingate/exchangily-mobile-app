import 'dart:convert';

import 'package:exchangilymobileapp/shared/globalLang.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logger.dart';
import '../base_state.dart';

class AnnouncementListScreenState extends BaseState {
  final log = getLogger('AnnouncementListScreenState');
  // DialogService dialogService = locator<DialogService>();
  // WalletService walletService = locator<WalletService>();
  // CoreWalletDatabaseService walletDatabaseService =
  //     locator<CoreWalletDatabaseService>();
  // SharedService sharedService = locator<SharedService>();
  BuildContext context;
  SharedPreferences prefs;
  List announceList = [];
  init() async {
    setBusy(true);
    prefs = await SharedPreferences.getInstance();
    List tempdata = prefs.getStringList('announceData');
    for (var element in tempdata) {
      announceList.add(jsonDecode(element));
      debugPrint('jsonData $announceList');
    }
    debugPrint("announceList from list page state: ");
    debugPrint(announceList.toString());
    setBusy(false);
  }

  updateReadStatus(index) {
    setBusy(true);
    log.i("updateReadStatus function: ");
    announceList[index]['isRead'] = true;
    debugPrint("announceList[$index]['isRead']: ${announceList[index]['isRead']}");
    //save cache
    List<String> jsonData = [];
    int readedNum = 0;
    for (var element in announceList) {
      element["isRead"] == false ? readedNum++ : readedNum = readedNum;
      jsonData.add(jsonEncode(element));
      debugPrint('jsonData $jsonData');
    }
    setunReadAnnouncement(readedNum);
    debugPrint("check status: ${prefs.containsKey('announceData')}");
    prefs.setStringList('announceData', jsonData);
    //save cache end
    setBusy(false);
  }
}
