import 'package:exchangilymobileapp/environments/environment_type.dart';

const String blockchainGateV2BaseUrl = isProduction
    ? 'https://prod.blockchaingate.com/v2/'
    : 'https://test.blockchaingate.com/v2/';

/*----------------------------------------------------------------------
                        Free Fab
----------------------------------------------------------------------*/

const String freeFabUrl = 'https://kanbanprod.fabcoinapi.com/kanban/getairdrop';
const String getFreeFabUrl =
    blockchainGateV2BaseUrl + 'airdrop/getQuestionair/';

const String postFreeFabUrl =
    blockchainGateV2BaseUrl + 'airdrop/answerQuestionair/';

/*----------------------------------------------------------------------
                        USD Coin Price
----------------------------------------------------------------------*/

const String usdCoinPriceUrl =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';
const String coinCurrencyUsdPriceUrl =
    'https://kanbanprod.fabcoinapi.com/USDvalues';

/*----------------------------------------------------------------------
                            Next
----------------------------------------------------------------------*/
