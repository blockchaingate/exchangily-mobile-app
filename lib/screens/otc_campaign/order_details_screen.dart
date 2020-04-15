import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/campaign/order_info.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignOrderDetailsScreen extends StatelessWidget {
  final List<OrderInfo> orderInfoList;
  const CampaignOrderDetailsScreen({Key key, this.orderInfoList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color containerListColor;
    Color evenOrOddColor(int index) {
      index.isOdd
          ? containerListColor = globals.walletCardColor
          : containerListColor = globals.grey.withAlpha(20);
      return containerListColor;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).orderDetails,
              style: Theme.of(context).textTheme.headline4),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(AppLocalizations.of(context).date,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Expanded(
                        flex: 3,
                        child: Text(AppLocalizations.of(context).quantity,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1)),
                    Expanded(
                      flex: 2,
                      child: Text(AppLocalizations.of(context).status,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1),
                    )
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                orderInfoList != null
                    ? Container(
                        height: MediaQuery.of(context).size.height - 150,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: orderInfoList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              color: evenOrOddColor(index),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        orderInfoList[index].dateCreated,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        orderInfoList[index]
                                            .quantity
                                            .toStringAsFixed(3),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(orderInfoList[index].status,
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
