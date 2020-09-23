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

final String coinCurrencyUsdPriceUrl =
    'https://kanbanprod.fabcoinapi.com/USDvalues';

/*----------------------------------------------------------------------
                            Get App Version
----------------------------------------------------------------------*/

final String getAppVersionUrl = baseKanbanUrl + 'getappversion';

/*----------------------------------------------------------------------
                            Get Coin Token List
----------------------------------------------------------------------*/

final String getTokenListUrl = baseKanbanUrl + 'exchangily/getTokenList';

/*----------------------------------------------------------------------
                            OTC
----------------------------------------------------------------------*/

final String otcKycCreateUrl = baseBlockchainGateV2Url + 'kyc/create';

final String countryList = 'https://exchangily.com/assets/countries.json';

final String otcListingUrl = baseBlockchainGateV2Url + 'otc-listing/';

final String getOtcPublicListingUrl =
    baseBlockchainGateV2Url + otcListingUrl + 'public/list';

final String getPrivateMemberOrdersUrl =
    baseBlockchainGateV2Url + 'orders/private/member-orders';

// Buy/Sell url with token = otcListingUrl/address/add-order

// Change orders status url = orders/5f18a49fc55b4d633ddb71e9/changePaymentStatus

/*----------------------------------------------------------------------
                        Constants
----------------------------------------------------------------------*/

final String coinPriceWSUrl = isProduction
    ? 'wss://kanbanprod.fabcoinapi.com/ws/allprices'
    : 'wss://kanbantest.fabcoinapi.com/ws/allprices';

final String testUsdtWalletAddress =
    '0x7bfbfaf1d3f81827e1642114c7905de413d83321';

final String prodUsdtWalletAddress =
    '0x4e93c47b42d09f61a31f798877329890791077b2';

// Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
final String coinCurrencyUsdValueUrl = baseKanbanUrl + 'USDvalues';
final String pairDecimalConfigUrl = baseKanbanUrl + 'kanban/getpairconfig';
final String redepositStatusUrl = baseKanbanUrl + 'checkstatus/';
