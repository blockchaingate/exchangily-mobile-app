import 'package:exchangilymobileapp/environments/environment_type.dart';

/*----------------------------------------------------------------------
                        Base Url's
----------------------------------------------------------------------*/

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

final String usdCoinPriceUrl =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';

final String coinPricesWSUrl = kanbanBaseWSUrl + 'allprices';
// Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
final String coinCurrencyUsdValueUrl = baseKanbanUrl + 'USDvalues';

/*----------------------------------------------------------------------
                            Get App Version
----------------------------------------------------------------------*/

final String getAppVersionUrl = baseKanbanUrl + 'getappversion';

/*----------------------------------------------------------------------
                Get Token List, Decimal config, checkstatus
----------------------------------------------------------------------*/

final String getTokenListUrl = baseKanbanUrl + 'exchangily/getTokenList';

final String pairDecimalConfigUrl = baseKanbanUrl + 'kanban/getpairconfig';
final String redepositStatusUrl = baseKanbanUrl + 'checkstatus/';
/*----------------------------------------------------------------------
                            Exchange
----------------------------------------------------------------------*/

// /ordersbyaddresspaged/:address/:start?/:count?/:status?
// /getordersbytickernamepaged/:address/:tickerName/:start?/:count?/:status?

// Below is the address type which is used in ordersPaged
// convert base58 fab address to hex. trim the first two and last 8 chars.
// then put a 0x in front

final String getOrdersPagedByFabHexAddressURL =
    baseKanbanUrl + '/ordersbyaddresspaged/';
final String getOrdersPagedByFabHexAddressAndTickerNameURL =
    baseKanbanUrl + '/getordersbytickernamepaged/';

final String kanbanBaseWSUrl = isProduction
    ? 'wss://kanbanprod.fabcoinapi.com/ws/'
    : 'wss://kanbantest.fabcoinapi.com/ws/';

final String allPricesWSUrl = kanbanBaseWSUrl + 'allPrices';
final String tradesWSUrl = kanbanBaseWSUrl + 'trades@';
final String ordersWSUrl = kanbanBaseWSUrl + 'orders@';
final String tickerWSUrl = kanbanBaseWSUrl + 'ticker@';
/*----------------------------------------------------------------------
                        Campaign
----------------------------------------------------------------------*/
final String testUsdtWalletAddress =
    '0x7bfbfaf1d3f81827e1642114c7905de413d83321';

final String prodUsdtWalletAddress =
    '0x4e93c47b42d09f61a31f798877329890791077b2';
