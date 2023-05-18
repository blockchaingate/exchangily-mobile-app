import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import 'package:launch_review/launch_review.dart';
import 'dart:io' show Platform;
import 'package:package_info/package_info.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class VersionService {
  final log = getLogger('VersionService');
  final client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  final SharedService? sharedService = locator<SharedService>();

  String iosStoreUrl =
      "https://apps.apple.com/ca/app/exchangily-dex-wallet/id1503068552";
  String androidStoreUrl =
      "https://www.play.google.com/store/apps/details?id=com.exchangily.wallet";
  String androidSdkDownloadUrl = "https://exchangily.com/download/latest.apk";

  Future getAppVersionInfo() async {
    String os = "";

    if (Platform.isAndroid) {
      os = "android";
    } else if (Platform.isIOS) {
      os = "ios";
    }

    debugPrint('My os: $os');
    try {
      debugPrint("appVersionUrl: " + appVersionUrl);
      var response = await client.get(Uri.parse(appVersionUrl));
      var json = response.body;
      if (json != null) {
        log.w('get version info $json}');
        return json;
      } else {
        return "error";
      }
    } catch (err) {
      log.e('get version info CATCH $err');
      // throw Exception(err);
      return "error";
    }
  }

  getAppStoreUrl() {
    if (Platform.isAndroid) {
      return androidStoreUrl;
    } else if (Platform.isIOS) {
      return iosStoreUrl;
    }
  }

  openAppStore() async {
    LaunchReview.launch(
        androidAppId: "com.exchangily.wallet",
        iOSAppId: "id1503068552",
        writeReview: false);
  }

  downloadSdk() async {
    if (await canLaunch(androidSdkDownloadUrl)) {
      log.i('androidSdkDownloadUrl $androidSdkDownloadUrl');
      await launch(androidSdkDownloadUrl);
    } else {
      throw 'Could not launch $androidSdkDownloadUrl';
    }
  }

  _downloadTestFlight() async {
    String url = "https://www.apps.apple.com/ca/app/exchangily-dex-wallet";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  downloadWithLink(String link) async {
    String url = link;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future checkVersion(context, {isForceUpdate = false}) async {
    try {
      await getAppVersionInfo().then((appVersionFromApi) async {
        if (appVersionFromApi == "error") {
          log.e("checkVersion has error!");
        } else {
          log.i("Have Res info");
          var versionInfo = await sharedService!.getLocalAppVersion();
          log.i('getAppVersion $versionInfo');
          var versionName = versionInfo['name']!;
          var buildNumber = versionInfo['buildNumber']!;
          var localVersion = versionName + '.' + buildNumber;
          log.i('local version $localVersion');
          Version currentVersion = Version.parse(localVersion);
          debugPrint("userVersion: " + localVersion);

          Version latestVersion = Version.parse(appVersionFromApi);

          debugPrint("latestVersion: " + appVersionFromApi);

          if (latestVersion > currentVersion) {
            showMyDialog(latestVersion, context, currentVersion,
                isForceUpdate: isForceUpdate);
          }
        }
      });
    } catch (err) {
      log.e('Check version CATCh $err');
    }
  }

  Future<void> showMyDialog(latestVersion, context, userVersion,
      {isForceUpdate = false}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: !isForceUpdate, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          content: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
                margin: const EdgeInsets.only(top: 12.0, right: 6.0),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          AppLocalizations.of(context)!.appUpdateNotice,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    UIHelper.divider,
                    const SizedBox(
                      height: 20,
                    ),
                    Text("${AppLocalizations.of(context)!.currentVersion}:  " +
                        userVersion.toString()),
                    UIHelper.verticalSpaceSmall,
                    Text(
                      "${AppLocalizations.of(context)!.latestVersion}:  " +
                          latestVersion.toString(),
                      style: TextStyle(color: Colors.greenAccent[100]),
                    ),
                    // Text("Force Update: " + latestVersion['forceUpdate'].toString()),
                    const SizedBox(
                      height: 20,
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: latestVersion['link']
                    //       .map<Widget>((l) => TextButton(
                    //           style: ButtonStyle(
                    //               backgroundColor:
                    //                   MaterialStateProperty.all<Color>(
                    //                       primaryColor)),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 l['name'],
                    //                 style: const TextStyle(color: Colors.white),
                    //               ),
                    //             ],
                    //           ),
                    //           onPressed: () {
                    //             _downloadWithLink(l['link']);
                    //           }))
                    //       .toList(),
                    // ),
                    Offstage(
                      offstage: !(Platform.isAndroid),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 5,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              primaryColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .downloadLatestApkFromServer,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    downloadSdk();
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 5,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              priceColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Google Play',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    openAppStore();
                                  }),
                            )
                          ]),
                    ),
                    Offstage(
                      offstage: !(Platform.isIOS),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Flexible(
                            //   flex: 5,
                            //   child: TextButton(
                            //       style: ButtonStyle(
                            //           backgroundColor:
                            //               MaterialStateProperty.all<Color>(
                            //                   primaryColor)),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: const [
                            //           Text(
                            //             'TestFlight',
                            //             style: TextStyle(color: Colors.white),
                            //           ),
                            //         ],
                            //       ),
                            //       onPressed: () {
                            //         _downloadTestFlight();
                            //       }),
                            // ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            Flexible(
                              flex: 5,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              priceColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'App Store',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    openAppStore();
                                  }),
                            )
                          ]),
                    )
                  ],
                ),
              ),
              // Positioned(
              //   right: 0.0,
              //   child: latestVersion['forceUpdate']
              //       ? Container()
              //       : GestureDetector(
              //           onTap: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: const Align(
              //             alignment: Alignment.topRight,
              //             child: CircleAvatar(
              //               radius: 12.0,
              //               backgroundColor: Colors.white,
              //               child: Icon(Icons.close, color: Color(0xff000000)),
              //             ),
              //           ),
              //         ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
