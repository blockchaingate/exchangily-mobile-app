import 'dart:async';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampaignInstructionsScreenState extends BaseState {
  final log = getLogger('CampaignInstructionsScreenState');
  final String reffer1AssetName = 'assets/images/otc-campaign/reffer.svg';
  final List<String> campaignAssetNames = <String>[
    'assets/images/otc-campaign/reffer.svg',
    'assets/images/otc-campaign/reffer3.svg',
    'assets/images/otc-campaign/reffer5.svg'
  ];
  final List<Widget> _tierListSvg = <Widget>[];
  List<Widget> get tierListSvg => _tierListSvg;

  // Init state
  initState() {
    // circular indicator is still not working when page first loads
    setBusy(true);
    Timer(Duration(seconds: 1), () {
      for (String assetName in campaignAssetNames) {
        _tierListSvg.add(SvgPicture.asset(
          assetName,
          fit: BoxFit.contain,
          semanticsLabel: 'Tier 1,2,3 instruction',
        ));
      }
      setBusy(false);
    });
  }
}
