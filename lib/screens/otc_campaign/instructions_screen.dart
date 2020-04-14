import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignInstructionScreen extends StatelessWidget {
  const CampaignInstructionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignInstructionsScreenState>(
      onModelReady: (model) async {
        model.context = context;
        await model.initState();
      },
      builder: (context, model, child) => Container(
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).campaignInstructions,
                  style: Theme.of(context).textTheme.headline3)),
          key: key,
          body: model.busy
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      // width: 250,
                      child: Center(
                        child: Theme.of(context).platform == TargetPlatform.iOS
                            ? ClassicHeader()
                            : Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.grey,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .checkingAccountDetails,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color: globals.primaryColor))),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            // Container(
                            //   child: Image.asset(
                            //       'assets/images/otc-campaign/guide-about-campaign-en-png.png'),
                            // ),

                            // if (model.pdfViewerService.path != null)
                            //   Container(
                            //     height: 300,
                            //     child: PdfViewer(
                            //         filePath: model.pdfViewerService.path),
                            //   )
                            // else
                            //   Text('Pdf is not loaded'),
                            // RaisedButton(
                            //   child: Text('Load Pdf'),
                            //   onPressed: () {
                            //     model.loadPdf();
                            //   },
                            // )
                          ],
                        )),
                    // List of instruction SVG images
                    Expanded(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height - 100,
                          child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return model.tierListSvg[index];
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(color: Colors.blueGrey),
                            itemCount: model.tierListSvg.length,
                          )),
                    ),

                    // Enter button container

                    Container(
                      width: 250,
                      child: RaisedButton(
                        padding: EdgeInsets.all(0),
                        child: Text(
                            AppLocalizations.of(context)
                                .tapHereToEnterInCampaign,
                            style: Theme.of(context).textTheme.headline4),
                        onPressed: () {
                          Navigator.pushNamed(context, '/campaignLogin');
                        },
                      ),
                    ),
                    UIHelper.verticalSpaceSmall,
                  ],
                ),
        ),
      ),
    );
  }
}
