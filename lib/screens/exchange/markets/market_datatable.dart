import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/service_locator.dart';

class MarketDataTable extends StatefulWidget {
  final List<Price> pairList;
  MarketDataTable(this.pairList);

  @override
  _MarketDataTableState createState() => _MarketDataTableState(pairList);
}

class _MarketDataTableState extends State<MarketDataTable> {
  _MarketDataTableState(this.pairList);
  List<Price> pairList;

  List<Price> cpPairList;

  final NavigationService navigationService = locator<NavigationService>();
  final List titles = [
    'Ticker',
    'Price',
    'High',
    'Low',
    'Change',
  ];

  // List titles;

  bool _sortNameAsc = true;
  bool _sortPriceAsc = true;
  bool _sortHighAsc = true;
  bool _sortLowAsc = true;
  bool _sortChangeAsc = true;

  bool _sortAsc = true;
  int _sortColumnIndex;

  @override
  void initState() {
    // titles = [
    //   AppLocalizations.of(context).ticker,
    //   AppLocalizations.of(context).price,
    //   AppLocalizations.of(context).high,
    //   AppLocalizations.of(context).low,
    //   AppLocalizations.of(context).change,
    // ];
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        pairList
            .sort((a, b) => a.symbol.toString().compareTo(b.symbol.toString()));
      } else {
        pairList
            .sort((a, b) => b.symbol.toString().compareTo(a.symbol.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      //Use the theme to change data table sort icon color
      data: ThemeData.dark(),
      child: DataTable(
          dataRowHeight: 60,
          sortAscending: _sortAsc,
          sortColumnIndex: _sortColumnIndex,
          horizontalMargin: 7,
          columnSpacing: 0,
          columns: [
            DataColumn(
              label: Container(
                width: MediaQuery.of(context).size.width * 3 / 11,
                child: Text(
                  AppLocalizations.of(context).ticker,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                // print("Sort Datatable");
                // print("columnIndex: " + columnIndex.toString());
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortNameAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortNameAsc;
                  }
                  if (sortAscending) {
                    pairList.sort((a, b) =>
                        a.symbol.toString().compareTo(b.symbol.toString()));
                  } else {
                    pairList.sort((a, b) =>
                        b.symbol.toString().compareTo(a.symbol.toString()));
                  }
                });
              },
            ),
            DataColumn(
              label: Container(
                width: MediaQuery.of(context).size.width * 2 / 11,
                child: Text(
                  AppLocalizations.of(context).price,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                // print("Sort Datatable");
                // print("columnIndex: " + columnIndex.toString());
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortPriceAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortPriceAsc;
                  }
                  if (sortAscending) {
                    pairList.sort((a, b) =>
                        a.price.compareTo(b.price));
                  } else {
                    pairList.sort((a, b) =>
                        b.price.compareTo(a.price));
                  }
                });
              },
            ),
            DataColumn(
              label: Container(
                width: MediaQuery.of(context).size.width * 2 / 11,
                child: Text(
                  AppLocalizations.of(context).high,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortHighAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortHighAsc;
                  }
                  if (sortAscending) {
                    pairList.sort((a, b) =>
                        a.high.compareTo(b.high));
                  } else {
                    pairList.sort((a, b) =>
                        b.high.compareTo(a.high));
                  }
                });
              },
            ),
            DataColumn(
              label: Container(
                width: MediaQuery.of(context).size.width * 2 / 11,
                child: Text(
                  AppLocalizations.of(context).low,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortLowAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortLowAsc;
                  }
                  if (sortAscending) {
                    pairList.sort(
                        (a, b) => a.low.compareTo(b.low));
                  } else {
                    pairList.sort(
                        (a, b) => b.low.compareTo(a.low));
                  }
                });
              },
            ),
            DataColumn(
              label: Container(
                width: MediaQuery.of(context).size.width * 2 / 11,
                child: Text(
                  AppLocalizations.of(context).change,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortChangeAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortChangeAsc;
                  }
                  if (sortAscending) {
                    pairList.sort((a, b) =>
                        a.change.compareTo(b.change));
                  } else {
                    pairList.sort((a, b) =>
                        b.change.compareTo(a.change));
                  }
                });
              },
            ),
          ],

          // titles
          //     .map(
          //       (e) => DataColumn(
          //         label: Container(
          //           width: titles[0] == e
          //               ? MediaQuery.of(context).size.width * 3 / 11
          //               : MediaQuery.of(context).size.width * 2 / 11,
          //           child: Text(
          //             e,
          //             style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize:14),
          //           ),
          //         ),
          //         onSort: (columnIndex, ascending) {
          //           if(){

          //           }
          //           setState(() {
          //             sort.map((e) => {e == false});
          //             sort[columnIndex] = true;
          //             _sortColumnIndex = columnIndex;
          //           });
          //           onSortColum(columnIndex, ascending);
          //         },
          //       ),
          //     )
          //     .toList(),
          rows: pairList
              .map((itemRow) => DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          // width: MediaQuery.of(context).size.width * 3 / 11,
                          // color: Colors.green,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  itemRow.symbol.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context).vol +
                                      ': ${itemRow.volume.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          itemRow.symbol =
                              itemRow.symbol.replaceAll('/', '').toString();
                          navigationService.navigateTo('/exchangeTrade',
                              arguments: itemRow);
                        },
                      ),
                      DataCell(
                        Container(
                          child: Text(itemRow.price.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                              textAlign: TextAlign.start),
                        ),
                        onTap: () {
                          itemRow.symbol =
                              itemRow.symbol.replaceAll('/', '').toString();
                          navigationService.navigateTo('/exchangeTrade',
                              arguments: itemRow);
                        },
                      ),
                      DataCell(
                        Text(
                          itemRow.high.toString(),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        onTap: () {
                          itemRow.symbol =
                              itemRow.symbol.replaceAll('/', '').toString();
                          navigationService.navigateTo('/exchangeTrade',
                              arguments: itemRow);
                        },
                      ),
                      DataCell(
                        Text(
                          itemRow.low.toString(),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        onTap: () {
                          itemRow.symbol =
                              itemRow.symbol.replaceAll('/', '').toString();
                          navigationService.navigateTo('/exchangeTrade',
                              arguments: itemRow);
                        },
                      ),
                      DataCell(
                        Text(
                          itemRow.change >= 0
                              ? "+" + itemRow.change.toStringAsFixed(2) + '%'
                              : itemRow.change.toStringAsFixed(2) + '%',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Color(itemRow.change >= 0
                                  ? 0XFF0da88b
                                  : 0XFFe2103c),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                        onTap: () {
                          itemRow.symbol =
                              itemRow.symbol.replaceAll('/', '').toString();
                          navigationService.navigateTo('/exchangeTrade',
                              arguments: itemRow);
                        },
                      ),
                    ],
                  ))
              .toList()),
    );
  }
}

// DataColumn(
//             label: Container(
//               width: MediaQuery.of(context).size.width * 3 / 11,
//               child: Text(
//                 titles[0],
//                 style: Theme.of(context).textTheme.subtitle2,
//               ),
//             ),
//             onSort: (columnIndex, ascending) {
//               setState(() {
//                 sort = !sort;
//               });
//               onSortColum(columnIndex, ascending);
//             },
//           ),
//           DataColumn(
//             label: Container(
//               width: MediaQuery.of(context).size.width * 2 / 11,
//               child: Text(
//                 titles[1],
//                 style: Theme.of(context).textTheme.subtitle2,
//               ),
//             ),
//             onSort: (columnIndex, ascending) {
//               setState(() {
//                 sort = !sort;
//               });
//               onSortColum(columnIndex, ascending);
//             },
//           ),
//           DataColumn(
//             label: Container(
//               width: MediaQuery.of(context).size.width * 2 / 11,
//               child: Text(
//                 titles[2],
//                 style: Theme.of(context).textTheme.subtitle2,
//               ),
//             ),
//             onSort: (columnIndex, ascending) {
//               setState(() {
//                 sort = !sort;
//               });
//               onSortColum(columnIndex, ascending);
//             },
//           ),
//           DataColumn(
//             label: Container(
//               width: MediaQuery.of(context).size.width * 2 / 11,
//               child: Text(
//                 titles[3],
//                 style: Theme.of(context).textTheme.subtitle2,
//               ),
//             ),
//             onSort: (columnIndex, ascending) {
//               setState(() {
//                 sort = !sort;
//               });
//               onSortColum(columnIndex, ascending);
//             },
//           ),
//           DataColumn(
//             label: Container(
//               width: MediaQuery.of(context).size.width * 2 / 11,
//               child: Text(
//                 titles[0],
//                 style: Theme.of(context).textTheme.subtitle2,
//               ),
//             ),
//             onSort: (columnIndex, ascending) {
//               setState(() {
//                 sort = !sort;
//               });
//               onSortColum(columnIndex, ascending);
//             },
//           ),
