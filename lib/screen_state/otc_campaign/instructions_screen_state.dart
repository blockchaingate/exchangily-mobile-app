import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampaignInstructionsScreenState extends BaseState {
  final String reffer1AssetName = 'assets/images/otc-campaign/reffer.svg';
  final List<String> campaignAssetNames = <String>[
    'assets/images/otc-campaign/reffer.svg',
    'assets/images/otc-campaign/reffer.svg',
    'assets/images/otc-campaign/reffer.svg'
  ];
  final List<Widget> _tierListSvg = <Widget>[];
  List<Widget> get tierListSvg => _tierListSvg;

  // Init state
  initState() {
    for (String assetName in campaignAssetNames) {
      _tierListSvg.add(SvgPicture.asset(
        assetName,
        fit: BoxFit.contain,
        semanticsLabel:
            'Tier 1 instruction, if user has 1 refferal then user will earn 10% reward by 1 level below',
      ));
    }
  }
}
