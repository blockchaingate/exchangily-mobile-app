import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:package_info/package_info.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class VersionService {
  final log = getLogger('VersionService');
  final client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();

  String iosStoreUrl =
      "https://apps.apple.com/ca/app/exchangily-dex-wallet/id1503068552";
  String androidStoreUrl =
      "https://play.google.com/store/apps/details?id=com.exchangily.wallet";

  //api-ts production api
  String app = "exchangily";

  //api-ts production api
  // String url = "http://52.194.202.239:3000/app-update";

  //local test
  String url = "http://192.168.0.186:3000/app-update";

/*----------------------------------------------------------------------
                Get Tron Ts wallet balance
----------------------------------------------------------------------*/

  Future getVersionInfo() async {
    log.i("Will get version info!");
    // var body = {"address": address, "visible": true};

    String os = "";

    if (Platform.isAndroid) {
      os = "android";
    } else if (Platform.isIOS) {
      os = "ios";
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;

    print('My os: $os, my version: $version ');
    try {
      String fullURL =
          url + "?version=" + version + "&os=" + os + "&app=" + app;
      print("fullURL: " + fullURL);
      var response = await client.get(fullURL);
      var json = jsonDecode(response.body);
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

  _launchURL() async {
    String url = getAppStoreUrl();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _downloadSdk() async {
    String url = "https://exchangily.com/download/latest.apk";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _downloadTestFlight() async {
    String url = "https://exchangily.com/download/latest.apk";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _downloadWithLink(String link) async {
    String url = link;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future checkVersion(context) async {
    await getVersionInfo().then((res) async {
      if (res == "error") {
        log.e("checkVersion has error!");
      } else {
        log.i("Have Res info");

        // PackageInfo packageInfo = await PackageInfo.fromPlatform();
        // String userVersion = (packageInfo.version).toString();
        Version currentVersion = Version.parse(res['userVersion']);
        print("userVersion: " + res['userVersion']);

        Version latestVersion = Version.parse(res['data']['version']);

        print("latestVersion: " + res['data']['version']);

        if (res['status'] == 'good' && latestVersion > currentVersion) {
          _showMyDialog(res['data'], context, res['userVersion']);
        }
      }
    });
  }

  Future<void> _showMyDialog(res, context, userVersion) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // title: new
          content: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 15),
                margin: EdgeInsets.only(top: 12.0, right: 6.0),
                decoration: BoxDecoration(
                    color: Color(0xff333333),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "App Update Available",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new Text("Current Version: " + userVersion),
                    new Text("Lastest Version: " + res['version']),
                    new Text("Force Update: " + res['forceUpdate'].toString()),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: res['link']
                          .map<Widget>((l) => TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          primaryColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l['name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _downloadWithLink(l['link']);
                              }))
                          .toList(),
                    )
                    // Offstage(
                    //   offstage: !(Platform.isAndroid),
                    //   child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         Flexible(
                    //           flex: 5,
                    //           child: TextButton(
                    //               style: ButtonStyle(
                    //                   backgroundColor:
                    //                       MaterialStateProperty.all<Color>(
                    //                           primaryColor)),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     'Download SDK',
                    //                     style: TextStyle(color: Colors.white),
                    //                   ),
                    //                 ],
                    //               ),
                    //               onPressed: () {
                    //                 _downloadSdk();
                    //               }),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Flexible(
                    //           flex: 5,
                    //           child: TextButton(
                    //               style: ButtonStyle(
                    //                   backgroundColor:
                    //                       MaterialStateProperty.all<Color>(
                    //                           tertiaryColor)),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     'Google PLay',
                    //                     style: TextStyle(color: Colors.white),
                    //                   ),
                    //                 ],
                    //               ),
                    //               onPressed: () {
                    //                 // Navigator.of(context).pop();
                    //                 _launchURL();
                    //               }),
                    //         )
                    //       ]),
                    // ),
                    // Offstage(
                    //   offstage: !(Platform.isIOS),
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         Flexible(
                    //           flex: 5,
                    //           child: TextButton(
                    //               style: ButtonStyle(
                    //                   backgroundColor:
                    //                       MaterialStateProperty.all<Color>(
                    //                           primaryColor)),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     'TestFlight',
                    //                     style: TextStyle(color: Colors.white),
                    //                   ),
                    //                 ],
                    //               ),
                    //               onPressed: () {
                    //                 _downloadTestFlight();
                    //               }),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Flexible(
                    //           flex: 5,
                    //           child: TextButton(
                    //               style: ButtonStyle(
                    //                   backgroundColor:
                    //                       MaterialStateProperty.all<Color>(
                    //                           tertiaryColor)),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                     'App Store',
                    //                     style: TextStyle(color: Colors.white),
                    //                   ),
                    //                 ],
                    //               ),
                    //               onPressed: () {
                    //                 // Navigator.of(context).pop();
                    //                 _launchURL();
                    //               }),
                    //         )
                    //       ]),
                    // )
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: res['forceUpdate']
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 12.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Color(0xff000000)),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
