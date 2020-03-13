import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampaignInstructionsScreenState extends BaseState {
  final String reffer1AssetName = 'assets/images/otc-campaign/reffer.svg';
  final List<String> campaignAssetNames = <String>[
    'assets/images/otc-campaign/reffer.svg',
    'assets/images/otc-campaign/reffer3.svg',
    'assets/images/otc-campaign/reffer5.svg'
  ];
  final List<Widget> _tierListSvg = <Widget>[];
  List<Widget> get tierListSvg => _tierListSvg;
  // Later change this after checking if user has paid or not
  bool isPaid = false;

  // Init state
  initState() {
    // circular indicator is still not working when page first loads
    setState(ViewState.Busy);
    for (String assetName in campaignAssetNames) {
      _tierListSvg.add(SvgPicture.asset(
        assetName,
        fit: BoxFit.contain,
        semanticsLabel:
            'Tier 1,2,3 instruction, if user has 1 refferal then user will earn 10% reward by 1 level below',
      ));
    }
    setState(ViewState.Idle);
  }
}
