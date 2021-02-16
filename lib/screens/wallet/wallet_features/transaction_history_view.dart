import 'package:exchangilymobileapp/constants/colors.dart' as colors;
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

class TransactionHistoryView extends StatelessWidget {
  final String tickerName;
  TransactionHistoryView({Key key, this.tickerName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double customFontSize = 12;
    return ViewModelBuilder<TransactionHistoryViewmodel>.reactive(
      viewModelBuilder: () =>
          TransactionHistoryViewmodel(tickerName: tickerName),
      onModelReady: (model) async {
        model.context = context;
        model.getWalletFromDb();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).transactionHistory,
              style: Theme.of(context).textTheme.headline3),
          backgroundColor: colors.secondaryColor,
        ),
        body: !model.dataReady || model.isBusy
            ? Container(
                width: double.infinity,
              height: 300,
                child: model.sharedService.loadingIndicator())
            : model.transactionHistoryToShowInView.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                        child: Icon(Icons.insert_drive_file,
                            color: colors.white)))
                : Container(
                    padding: EdgeInsets.all(4.0),
                    child: Column(
                      children: <Widget>[
                      //  IconButton(icon:Icon(Icons.ac_unit,color:colors.white),onPressed: ()=> model.test(),),
                        Row(
                          
                          children: [UIHelper.horizontalSpaceSmall, Text(
                                                  'Action',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),UIHelper.horizontalSpaceMedium,UIHelper.horizontalSpaceSmall,
                            
                           Expanded(flex: 1,
                                                          child: Text(
                                                  AppLocalizations.of(context)
                                                      .date,textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),
                           ),
 Expanded(flex: 2,
    child: Text(
                                                  AppLocalizations.of(context)
                                                      .quantity,textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),
 ),
                                                     Expanded(flex: 1,
                                                                                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .status,textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2),
                                                     ),
                                                         Expanded(flex: 1,
                                                                                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .details,textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2),
                                                     ),
                        ],),
                         model.isBusy
                              ? CircularProgressIndicator()
                              : 
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                          
                            itemCount: model.transactionHistoryToShowInView.length,
                            itemBuilder: (context, index) {
return 


TxHisotryCard(customFontSize: customFontSize,transaction: model.transactionHistoryToShowInView[index],model:model);

// return Card(
//         elevation: 4,
//         child: Container(
        
//           padding: EdgeInsets.symmetric(
//               vertical: 8.0),
//           color: colors.walletCardColor,
//           child: Row(
//             children: <Widget>[
           
//               Expanded(flex:1,
//                                                             child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
//                   // mainAxisAlignment:
//                   //     MainAxisAlignment.spaceEvenly,
               
//                   children: [
//                     Container(
                  
//                       margin: EdgeInsets.only(left:4),
//                       child: Padding(
//                         padding: model.transactionHistoryToShowInView[index].tickerName.length > 3?const EdgeInsets.only(left:0.0): const EdgeInsets.only(left:5.0),
//                         child: Text(
//                             '${model.transactionHistoryToShowInView[index].tickerName}',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle2),
//                       ),
//                     ),
               
//                     // icon
//                     model.transactionHistoryToShowInView[index].tag.toUpperCase() ==
//                             model.deposit
//                                 .toUpperCase()
//                         ? Padding(
//                           padding: const EdgeInsets.only(left:10.0),
//                           child: Icon(
//                               Icons.arrow_downward,
//                               size: 16,
//                               color: colors.buyPrice,
//                             ),
//                         )
//                         : Padding(
//                           padding: const EdgeInsets.only(left:10.0),
//                           child: Icon(
//                               Icons.arrow_upward,
//                               size: 16,
//                               color: colors.sellPrice,
//                             ),
//                         ),

//                     if (model.transactionHistoryToShowInView[index].tag
//                             .toUpperCase() ==
//                         model.withdraw
//                             .toUpperCase())
//                       Padding(
//                         padding: const EdgeInsets.only(left:2.0),
//                         child: Text(
//                           AppLocalizations.of(context)
//                               .withdraw,
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle2,
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                     else if (model.transactionHistoryToShowInView[index].tag
//                             .toUpperCase() ==
//                         model.send.toUpperCase())
//                       Padding(
//                       padding:  const EdgeInsets.only(left:5.0),
//                         child: Text(
//                           AppLocalizations.of(context)
//                               .send,
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle2,
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                     else if (model.transactionHistoryToShowInView[index].tag
//                             .toUpperCase() ==
//                         model.deposit.toUpperCase())
//                       Padding(
//                                                                         padding:  const EdgeInsets.only(left:2.0),
//                         child: Text(
//                           AppLocalizations.of(context)
//                               .deposit,
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle2,
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                   ],
//                 ),
//               ),
         
//               // DATE
//               Expanded(flex: 1,
//                                                           child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       model.transactionHistoryToShowInView[index].date.split(" ")[0]
//                           ,
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline5
//                           .copyWith(
//                               fontWeight:
//                                   FontWeight
//                                       .w400),
//                     ),   Padding(
//                       padding: const EdgeInsets.only(top:4.0),
//                       child: Text(
//                       model.transactionHistoryToShowInView[index].tag == model.send? model.transactionHistoryToShowInView[index].date.split(" ")[1].split(".")[0]: 
//                        model.transactionHistoryToShowInView[index].date.split(" ")[1]
//                             ,
//                         style: Theme.of(context)
//                             .textTheme
//                             .subtitle2
//                             .copyWith(
//                                 fontWeight:
//                                     FontWeight
//                                         .bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
          
//               // Quantity
//               Expanded(flex: 2,
//                                                           child: Container(
//                                                             alignment: Alignment.center,
//                                                             child: Text(
//                   model.transactionHistoryToShowInView[index].quantity
//                       .toStringAsFixed(
//                           // model
//                           //   .decimalConfig
//                           //   .quantityDecimal
//                           2),textAlign: TextAlign.right,
//                   style: Theme.of(context)
//                       .textTheme
//                       .headline5
//                       .copyWith(
//                           fontWeight:
//                               FontWeight.w400),
//                 ),
//                                                           ),
//               ),
//               UIHelper.horizontalSpaceSmall,
//            //   UIHelper.horizontalSpaceMedium,
//               // Status
//               model.transactionHistoryToShowInView[index].tag != model.send
//                   ? Expanded(
//                               flex:1,                                    child: Container(
//                         child: Row(
//                           crossAxisAlignment:
//                               CrossAxisAlignment
//                                   .center,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
                          
                    
//                             // If deposit is success in both Ticker chain and kanabn chain then show completed
//                             if (model.transactionHistoryToShowInView[index].tag
//                                         .toUpperCase() ==
//                                     model.deposit
//                                         .toUpperCase() &&
//                                 model.transactionHistoryToShowInView[index]
//                                         .tickerChainTxStatus ==
//                                     model
//                                         .success &&
//                                 model.transactionHistoryToShowInView[index]
//                                         .kanbanTxStatus ==
//                                     model.success)
//                               Text(
//                                   firstCharToUppercase(
//                                       AppLocalizations.of(
//                                               context)
//                                           .completed),
//                                   style: TextStyle(
//                                       fontSize:
//                                           customFontSize,
//                                       color: colors
//                                           .buyPrice))
//                                             // If deposit is success in only Ticker chain and not in kanban chain then show sent
//                                          else if (model.transactionHistoryToShowInView[index].tag
//                                         .toUpperCase() ==
//                                     model.deposit
//                                         .toUpperCase() &&
//                                 model.transactionHistoryToShowInView[index]
//                                         .tickerChainTxStatus ==
//                                     model
//                                         .success &&
//                                 model.transactionHistoryToShowInView[index]
//                                         .kanbanTxStatus ==
//                                     model.success)
//                               Text(
//                                   firstCharToUppercase(
//                                       AppLocalizations.of(
//                                               context)
//                                           .sent),
//                                   style: TextStyle(
//                                       fontSize:
//                                           customFontSize,
//                                       color: colors
//                                           .buyPrice))
//                                           // depsoit pending if ticker chain staus is pending
//                             else if (model.transactionHistoryToShowInView[index].tag
//                                         .toUpperCase() ==
//                                     model.deposit
//                                         .toUpperCase()&&model.transactionHistoryToShowInView[index]
//                                     .tickerChainTxStatus ==
//                                 model.pending)
//                               Text(
//                                   firstCharToUppercase(
//                                       AppLocalizations.of(
//                                               context)
//                                           .pending),
//                                   style: TextStyle(
//                                       fontSize:
//                                           customFontSize,
//                                       color: colors
//                                           .yellow))
                          
//                             else if (model.transactionHistoryToShowInView[index].tag
//                                         .toUpperCase() ==
//                                     model.deposit
//                                         .toUpperCase()&&model.transactionHistoryToShowInView[index]
//                                         .kanbanTxStatus ==
//                                     model
//                                         .rejected ||
//                                 model.transactionHistoryToShowInView[index]
//                                         .kanbanTxStatus ==
//                                     model
//                                         .rejected)
                               
//                               RichText(
//                                 text: TextSpan(
//                                     text: AppLocalizations.of(
//                                             context)
//                                         .redeposit,
//                                     style: TextStyle(
//                                         fontSize:
//                                             12,
//                                         decoration:
//                                             TextDecoration
//                                                 .underline,
//                                         color: colors
//                                             .red),
//                                     recognizer:
//                                         TapGestureRecognizer()
//                                           ..onTap =
//                                               () {
//                                             model.navigationService.navigateTo(RedepositViewRoute,
//                                                 arguments: model.walletInfo);
//                                           }),
//                               )            // if withdraw status is success on kanban but null on ticker chain then display sent
//                             else if (model.transactionHistoryToShowInView[index]
//                                         .tag
//                                         .toUpperCase() ==
//                                     model
//                                         .withdraw
//                                         .toUpperCase() &&
//                                 model.transactionHistoryToShowInView[index]
//                                         .kanbanTxStatus ==
//                                     model.success && model.transactionHistoryToShowInView[index].tickerChainTxId == '')
//                               Text(
//                                   firstCharToUppercase(
//                                       AppLocalizations.of(
//                                               context)
//                                           .sent),
//                                   style: TextStyle(
//                                       fontSize:
//                                           customFontSize,
//                                       color: colors
//                                           .buyPrice))              // if withdraw status is success on kanban but null on ticker chain then display sent
//                             else if (model.transactionHistoryToShowInView[index]
//                                         .tag
//                                         .toUpperCase() ==
//                                     model
//                                         .withdraw
//                                         .toUpperCase() &&
//                                 model.transactionHistoryToShowInView[index]
//                                         .kanbanTxStatus ==
//                                     model.success && model.transactionHistoryToShowInView[index].tickerChainTxStatus.startsWith('sent'))
//                               Text(
//                                   firstCharToUppercase(
//                                       AppLocalizations.of(
//                                               context)
//                                           .completed),
//                                   style: TextStyle(
//                                       fontSize:
//                                           customFontSize,
//                                       color: colors
//                                           .buyPrice)),

//                           ],
//                         ),
//                       ),
//                   )
//                   : Expanded(flex:1,
//                                                                   child: Container(
                    
//                       child:Text(
//                                     firstCharToUppercase(
//                                         AppLocalizations.of(
//                                                 context)
//                                             .sent,),textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         fontSize:
//                                             customFontSize,
//                                         color: colors
//                                             .buyPrice))),
//                   ),
//                       Expanded(flex: 1,
//                                                                           child: Container(alignment: Alignment.centerRight,
//                                                                             child: IconButton(padding: EdgeInsets.zero, icon: Icon( Icons.more,color:colors.white,size:18),onPressed: (){ print('tx histoy ${model.transactionHistoryToShowInView[index].toJson()}');
//                                       model.showTxDetailDialog(
//                                           model.transactionHistoryToShowInView[index]);}),
//                                                                           ),
//                       )
//             ],
//           ),
//         ),
//       );




                            }),
                        ),
                        // for (var transaction
                        //     in model.transactionHistoryToShowInView)
                        //   model.isBusy
                        //       ? CircularProgressIndicator()
                        //       : TxHisotryCard(transaction: transaction, customFontSize: customFontSize),
                      ],
                    )),
      ),
    );
  }
}

class TxHisotryCard extends StatelessWidget {
  final TransactionHistoryViewmodel model;
  const TxHisotryCard({
  @required  this.model,
    Key key,
    @required this.transaction,
    @required this.customFontSize,
  }) : super(key: key);

  final TransactionHistory transaction;
  final double customFontSize;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        child: Container(
        
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          color: colors.walletCardColor,
          child: Row(
            children: <Widget>[
             
              Expanded(flex:1,
                                                            child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment:
                  //     MainAxisAlignment.spaceEvenly,
                 
                  children: [
                    Container(
                    
                      margin: EdgeInsets.only(left:4),
                      child: Padding(
                        padding: transaction.tickerName.length > 3?const EdgeInsets.only(left:0.0): const EdgeInsets.only(left:5.0),
                        child: Text(
                            '${transaction.tickerName}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2),
                      ),
                    ),
                 
                    // icon
                    transaction.tag.toUpperCase() ==
                            model.deposit
                                .toUpperCase()
                        ? Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Icon(
                              Icons.arrow_downward,
                              size: 16,
                              color: colors.buyPrice,
                            ),
                        )
                        : Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Icon(
                              Icons.arrow_upward,
                              size: 16,
                              color: colors.sellPrice,
                            ),
                        ),

                    if (transaction.tag
                            .toUpperCase() ==
                        model.withdraw
                            .toUpperCase())
                      Padding(
                        padding: const EdgeInsets.only(left:2.0),
                        child: Text(
                          AppLocalizations.of(context)
                              .withdraw,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (transaction.tag
                            .toUpperCase() ==
                        model.send.toUpperCase())
                      Padding(
                      padding:  const EdgeInsets.only(left:5.0),
                        child: Text(
                          AppLocalizations.of(context)
                              .send,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (transaction.tag
                            .toUpperCase() ==
                        model.deposit.toUpperCase())
                      Padding(
                                                                        padding:  const EdgeInsets.only(left:2.0),
                        child: Text(
                          AppLocalizations.of(context)
                              .deposit,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2,
                          textAlign: TextAlign.center,
                        ),
                      )
                  ],
                ),
              ),
         
              // DATE
              Expanded(flex: 1,
                                                          child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.date.split(" ")[0]
                          ,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(
                              fontWeight:
                                  FontWeight
                                      .w400),
                    ),   Padding(
                      padding: const EdgeInsets.only(top:4.0),
                      child: Text(
                      transaction.tag == model.send? transaction.date.split(" ")[1].split(".")[0]: 
                       transaction.date.split(" ")[1]
                            ,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(
                                fontWeight:
                                    FontWeight
                                        .bold),
                      ),
                    ),
                  ],
                ),
              ),
            
              // Quantity
              Expanded(flex: 2,
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: Text(
                  transaction.quantity
                      .toStringAsFixed(
                          // model
                          //   .decimalConfig
                          //   .quantityDecimal
                          2),textAlign: TextAlign.right,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(
                          fontWeight:
                              FontWeight.w400),
                ),
                                                          ),
              ),
              UIHelper.horizontalSpaceSmall,
           //   UIHelper.horizontalSpaceMedium,
              // Status
              transaction.tag != model.send
                  ? Expanded(
                              flex:1,                                    child: Container(
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            
                      
                            // If deposit is success in both Ticker chain and kanabn chain then show completed
                            if (transaction.tag
                                        .toUpperCase() ==
                                    model.deposit
                                        .toUpperCase() &&
                                transaction
                                        .tickerChainTxStatus ==
                                    model
                                        .success &&
                                transaction
                                        .kanbanTxStatus ==
                                    model.success)
                              Text(
                                  firstCharToUppercase(
                                      AppLocalizations.of(
                                              context)
                                          .completed),
                                  style: TextStyle(
                                      fontSize:
                                          customFontSize,
                                      color: colors
                                          .buyPrice))
                                            // If deposit is success in only Ticker chain and not in kanban chain then show sent
                                         else if (transaction.tag
                                        .toUpperCase() ==
                                    model.deposit
                                        .toUpperCase() &&
                                transaction
                                        .tickerChainTxStatus ==
                                    model
                                        .success &&
                                transaction
                                        .kanbanTxStatus ==
                                    model.success)
                              Text(
                                  firstCharToUppercase(
                                      AppLocalizations.of(
                                              context)
                                          .sent),
                                  style: TextStyle(
                                      fontSize:
                                          customFontSize,
                                      color: colors
                                          .buyPrice))
                                          // depsoit pending if ticker chain staus is pending
                            else if (transaction.tag
                                        .toUpperCase() ==
                                    model.deposit
                                        .toUpperCase()&&transaction
                                    .tickerChainTxStatus ==
                                model.pending)
                              Text(
                                  firstCharToUppercase(
                                      AppLocalizations.of(
                                              context)
                                          .pending),
                                  style: TextStyle(
                                      fontSize:
                                          customFontSize,
                                      color: colors
                                          .yellow))
                            
                            else if (transaction.tag
                                        .toUpperCase() ==
                                    model.deposit
                                        .toUpperCase()&&transaction
                                        .kanbanTxStatus ==
                                    model
                                        .rejected ||
                                transaction
                                        .kanbanTxStatus ==
                                    model
                                        .rejected)
                                 
                              RichText(
                                text: TextSpan(
                                    text: AppLocalizations.of(
                                            context)
                                        .redeposit,
                                    style: TextStyle(
                                        fontSize:
                                            12,
                                        decoration:
                                            TextDecoration
                                                .underline,
                                        color: colors
                                            .red),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap =
                                              () {
                                            model.navigationService.navigateTo(RedepositViewRoute,
                                                arguments: model.walletInfo);
                                          }),
                              )            // if withdraw status is success on kanban but null on ticker chain then display sent
                            else if (transaction
                                        .tag
                                        .toUpperCase() ==
                                    model
                                        .withdraw
                                        .toUpperCase() &&
                                transaction
                                        .kanbanTxStatus ==
                                    model.success && transaction.tickerChainTxId == '')
                              Text(
                                  firstCharToUppercase(
                                      AppLocalizations.of(
                                              context)
                                          .sent),
                                  style: TextStyle(
                                      fontSize:
                                          customFontSize,
                                      color: colors
                                          .buyPrice))              // if withdraw status is success on kanban but null on ticker chain then display sent
                            else if (transaction
                                        .tag
                                        .toUpperCase() ==
                                    model
                                        .withdraw
                                        .toUpperCase() &&
                                transaction
                                        .kanbanTxStatus ==
                                    model.success && transaction.tickerChainTxStatus.startsWith('sent'))
                              Text(
                                  firstCharToUppercase(
                                      AppLocalizations.of(
                                              context)
                                          .completed),
                                  style: TextStyle(
                                      fontSize:
                                          customFontSize,
                                      color: colors
                                          .buyPrice)),

                          ],
                        ),
                      ),
                  )
                  : Expanded(flex:1,
                                                                  child: Container(
                      
                      child:Text(
                                    firstCharToUppercase(
                                        AppLocalizations.of(
                                                context)
                                            .sent,),textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize:
                                            customFontSize,
                                        color: colors
                                            .buyPrice))),
                  ),
                      Expanded(flex: 1,
                                                                          child: Container(alignment: Alignment.centerRight,
                                                                            child: IconButton(padding: EdgeInsets.zero, icon: Icon( Icons.more,color:colors.white,size:18),onPressed: (){ print('tx histoy ${transaction.toJson()}');
                                      model.showTxDetailDialog(
                                          transaction);}),
                                                                          ),
                      )
            ],
          ),
        ),
      );
  }
}
