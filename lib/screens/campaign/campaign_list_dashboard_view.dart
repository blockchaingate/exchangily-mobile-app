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
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                centerTitle: true),
            body: model.isBusy
                ? model.sharedService.loadingIndicator()
                : Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                        itemCount: model.campaigns.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(children: [
                            Theme(
                              data: ThemeData(
                                  textTheme: Typography.material2018(
                                          platform: TargetPlatform.iOS)
                                      .black),
                              child: InkWell(
                                  splashColor: grey,
                                  onTap: () => print('1'),
                                  child:
                                      buildCampaignCard(model, index, context)),
                            ),
                            UIHelper.verticalSpaceSmall
                          ]);
                        }),
                  ),
            bottomNavigationBar: BottomNavBar(count: 3),
          );
        });
  }

  Card buildCampaignCard(
      CampaignListDashboardViewModel model, int index, BuildContext context) {
    print(model.campaigns[index].imageUrl);
    print(index);
    return Card(
        child: Container(
      margin: EdgeInsets.only(bottom: 5.0),
      width: 500,
      child: Column(children: [
        model.campaigns[index].imageUrl == null
            ? Container()
            : FadeInImage.assetNetwork(
                placeholder: '...',
                image: model.campaigns[index].imageUrl,
                fit: BoxFit.fill,
                width: double.maxFinite,
                height: 200),
        UIHelper.verticalSpaceSmall,
        Container(
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: Text('Campaign Name:')),
                  UIHelper.horizontalSpaceSmall,
                  Expanded(flex: 2, child: Text(model.campaigns[index].name)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('Last Updated on:')),
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                        flex: 2,
                        child: Text(model.campaigns[index].lastUpdated)),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text('Created on:')),
                  UIHelper.horizontalSpaceSmall,
                  Expanded(
                      flex: 2, child: Text(model.campaigns[index].dateCreated)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text('Status:')),
                  UIHelper.horizontalSpaceSmall,
                  if (model.campaigns[index].status == 1)
                    Expanded(flex: 2, child: Text('Active'))
                  else if (model.campaigns[index].status == 2)
                    Expanded(flex: 2, child: Text('Waiting'))
                ],
              ),
              UIHelper.verticalSpaceSmall,
              // Show if user participated then don't show
              // other wise show the button to participate
              model.campaigns[index].hasJoined != null &&
                      model.campaigns[index].hasJoined
                  ? Center(
                      child: OutlinedButton(
                          child: Text('Go to dashboard',
                              style: TextStyle(color: primaryColor)),
                          onPressed: () => {}))
                  : Center(
                      child: OutlinedButton(
                          child: Text('Click here to participate',
                              style: TextStyle(color: green)),
                          onPressed: () =>
                              {model.placeOrder(model.campaigns[index].id)}))
            ],
          ),
        ),
      ]),
    ));
  }
}
