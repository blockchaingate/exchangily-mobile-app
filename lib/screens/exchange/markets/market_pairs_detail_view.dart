import 'package:exchangilymobileapp/screens/exchange/markets/market_datatable.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;

class MarketPairPriceDetailView extends StatelessWidget {
  final List<Price>? pairList;
  MarketPairPriceDetailView({Key? key, this.pairList}) : super(key: key);
  final NavigationService? navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    // if (false)
    return ListView(children: [
      Container(
        color: globals.walletCardColor,
        child: FittedBox(
            // dataTable for trade page
            child: MarketDataTable(pairList)),
      )
    ]);
    // if (false)
    // return ListView.builder(
    //   itemCount: pairList.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Container(
    //       // decoration: BoxDecoration(
    //       //     border: Border(
    //       //         bottom: BorderSide(
    //       //             color: Theme.of(context).primaryColor, width: 0.51))),
    //       //  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
    //       child: Card(
    //         margin: EdgeInsets.only(top: 1.0),
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    //         child: InkWell(
    //           onTap: () {
    //             pairList[index].symbol =
    //                 pairList[index].symbol.replaceAll('/', '').toString();
    //             navigationService.navigateTo('/exchangeTrade',
    //                 arguments: pairList[index]);

    //             /// pause or cancel the all prices stream here
    //             /// and then find the way to resume this stream
    //             /// when user comes back to market view
    //             //model.pauseStream();
    //           },
    //           child: Container(
    //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    //             child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   UIHelper.horizontalSpaceSmall,
    //                   Expanded(
    //                     flex: 3,
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.only(bottom: 4.0),
    //                           child: Text(
    //                             pairList[index].symbol.toString(),
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .headline5
    //                                 .copyWith(fontWeight: FontWeight.w400),
    //                           ),
    //                         ),
    //                         Text(
    //                           'Vol: ${pairList[index].volume.toStringAsFixed(2)}',
    //                           style: Theme.of(context).textTheme.subtitle2,
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                   Expanded(
    //                     flex: 2,
    //                     child: Text(pairList[index].price.toString(),
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .headline6
    //                             .copyWith(fontWeight: FontWeight.w400),
    //                         textAlign: TextAlign.start),
    //                   ),
    //                   Expanded(
    //                     flex: 2,
    //                     child: Text(
    //                       pairList[index].high.toString(),
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .headline6
    //                           .copyWith(fontWeight: FontWeight.w400),
    //                     ),
    //                   ),
    //                   Expanded(
    //                     flex: 2,
    //                     child: Text(
    //                       pairList[index].low.toString(),
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .headline6
    //                           .copyWith(fontWeight: FontWeight.w400),
    //                     ),
    //                   ),
    //                   Expanded(
    //                     flex: 2,
    //                     child: Text(
    //                       pairList[index].change >= 0
    //                           ? "+" +
    //                               pairList[index].change.toStringAsFixed(2) +
    //                               '%'
    //                           : pairList[index].change.toStringAsFixed(2) + '%',
    //                       style: Theme.of(context).textTheme.headline6.copyWith(
    //                           color: Color(pairList[index].change >= 0
    //                               ? 0XFF0da88b
    //                               : 0XFFe2103c),
    //                           fontWeight: FontWeight.w400),
    //                     ),
    //                   ),
    //                 ]),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
