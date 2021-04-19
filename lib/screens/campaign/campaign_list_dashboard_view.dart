import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/screens/campaign/campaign_list_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CampaignListDashboardView extends StatelessWidget {
  const CampaignListDashboardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CampaignListDashboardViewModel(),
        onModelReady: (model) async {},
        builder: (context, CampaignListDashboardViewModel model, child) {
          return Scaffold(
            appBar: AppBar(
                flexibleSpace: Container(
                  decoration:
                      model.sharedService.rectangularGradientBoxDecoration(),
                ),
                title: Text(
                  'Campaign List',
                  style: Theme.of(context).textTheme.headline4,
                ),
                centerTitle: true),
            body: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                  itemCount: model.campaigns.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      InkWell(
                          splashColor: grey,
                          onTap: () => print('1'),
                          child: buildCampaignCard(model, index)),
                      UIHelper.verticalSpaceSmall
                    ]);
                  }),
            ),
            bottomNavigationBar: BottomNavBar(count: 3),
          );
        });
  }

  Card buildCampaignCard(CampaignListDashboardViewModel model, int index) =>
      Card(
          child: Container(
              width: 500,
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Text(model.campaigns[index].name),
                Text(model.campaigns[index].lastUpdated),
                Text(model.campaigns[index].dateCreated),
                // Image.network(model.campaigns[index].imageUrl, width: 35, height: 35)
              ])));
}
