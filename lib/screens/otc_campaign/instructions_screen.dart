import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
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
            key: key,
            body: Column(
              children: <Widget>[
                // Title container
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: globals.primaryColor))),
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Campaign Instructions',
                          style: Theme.of(context).textTheme.headline3),
                    )),
                // Buy container
                Container(
                  child: SizedBox(
                    width: 250,
                    child: RaisedButton(
                      padding: EdgeInsets.all(0),
                      child: Text('Tap here to enter in campaign',
                          style: Theme.of(context).textTheme.headline4),
                      onPressed: () {
                        Navigator.pushNamed(context, '/campaignPaymentScreen');
                      },
                    ),
                  ),
                ),
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
                      ))
              ],
            ),
            bottomNavigationBar: BottomNavBar(count: 3)),
      ),
    );
  }
}
