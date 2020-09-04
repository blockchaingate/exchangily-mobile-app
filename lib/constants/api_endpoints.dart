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
