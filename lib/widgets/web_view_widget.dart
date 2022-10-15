import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  final String url;
  final String title;
  const WebViewWidget(this.url, this.title);

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState(this.url);
}

class _WebViewWidgetState extends State<WebViewWidget>
    with TickerProviderStateMixin {
  bool isLoading = true;
  int loadingProgress = 0;
  AnimationController animationController;
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    animationController.repeat();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    //if (Platform.isIOS) WebView.platform = CupertinoWebView();
  }

  final String _url;
  final _key = UniqueKey();
  _WebViewWidgetState(this._url);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          WebView(
            // onProgress: ((progress) {
            //   widget.onCallBack(progress);
            //   setState(() {
            //     loadingProgress = progress;
            //   });
            //   debugPrint('loadingProgress $loadingProgress');
            // }),
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
              ),
            },
            key: _key,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: _url,
            //initialUrl: Uri.dataFromString(
            //   '<p>Web view sample</p>' * 1000,
            //    ).toString(),
          ),
          Visibility(
            child: Center(
                child: CircularProgressIndicator(
              color: primaryColor,
              valueColor: animationController
                  .drive(ColorTween(begin: secondaryColor, end: primaryColor)),
              //  value: double.parse(loadingProgress.toString()) / 100,
              semanticsValue: loadingProgress.toString(),
            )),
            visible: isLoading,
          )
        ],
      )),
    );
  }
}
