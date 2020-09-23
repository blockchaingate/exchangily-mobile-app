import 'package:exchangilymobileapp/environments/environment_type.dart';

final String baseBlockchainGateV2Url = isProduction
    ? 'https://blockchaingate.com/v2/'
    : 'https://test.blockchaingate.com/v2/';

final String baseKanbanUrl = isProduction
    ? 'https://kanbanprod.fabcoinapi.com/'
    : 'https://kanbantest.fabcoinapi.com/';

/*----------------------------------------------------------------------
                        Free Fab
----------------------------------------------------------------------*/
/// Url below not in use
const String freeFabUrl = 'https://kanbanprod.fabcoinapi.com/kanban/getairdrop';

final String getFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/getQuestionair/';

final String postFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/answerQuestionair/';

/*----------------------------------------------------------------------
                        USD Coin Price
----------------------------------------------------------------------*/

const String usdCoinPriceUrl =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';
const String coinCurrencyUsdPriceUrl =
    'https://kanbanprod.fabcoinapi.com/USDvalues';

/*----------------------------------------------------------------------
                            Get App Version
----------------------------------------------------------------------*/

final String getAppVersionUrl = baseKanbanUrl + 'getappversion';

/*----------------------------------------------------------------------
                            Get Token List
----------------------------------------------------------------------*/

final String getTokenListUrl = baseKanbanUrl + 'exchangily/getTokenList';

/*----------------------------------------------------------------------
                            Exchange

          /ordersbyaddresspaged/:address/:start?/:count?/:status?
----------------------------------------------------------------------*/

final String getOrdersPaged = baseKanbanUrl + '/ordersbyaddresspaged/';
final String getOrdersPagedByTickerName = baseKanbanUrl + '/getordersbytickernamepaged/';