import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../shared/globals.dart' as globals;

class CampaignInstructionScreen extends StatelessWidget {
  const CampaignInstructionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignInstructionsScreenState>(
      onModelReady: (model) {
        model.initState();
      },
      builder: (context, model, child) => Container(
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text('Campaign Instructions',
                  style: Theme.of(context).textTheme.headline3)),
          key: key,
          body: Column(
            children: <Widget>[
              // List of instruction SVG images
              model.state == ViewState.Busy
                  ? SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        backgroundColor: globals.primaryColor,
                      ))
                  : Expanded(
                      child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
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
                    )),

              // Buy container
              Container(
                child: SizedBox(
                    width: 250,
                    child: model.isPaid == false
                        ? RaisedButton(
                            padding: EdgeInsets.all(0),
                            child: Text('Tap here to enter in campaign',
                                style: Theme.of(context).textTheme.headline4),
                            onPressed: () {
                              Navigator.pushNamed(context, '/campaignPayment');
                            },
                          )
                        : RaisedButton(
                            padding: EdgeInsets.all(0),
                            child: Text('Go to dashboard',
                                style: Theme.of(context).textTheme.headline4),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/campaignDashboard');
                            },
                          )),
              ),
              UIHelper.horizontalSpaceSmall,
            ],
          ),
        ),
      ),
    );
  }
}
