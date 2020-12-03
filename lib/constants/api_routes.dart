import 'package:exchangilymobileapp/environments/environment_type.dart';

/*----------------------------------------------------------------------
                        Base Url's
----------------------------------------------------------------------*/

const String baseBlockchainGateV2Url = isProduction
    ? 'https://blockchaingate.com/v2/'
    : 'https://test.blockchaingate.com/v2/';

final String walletCoinsLogoUrl = "https://www.exchangily.com/assets/coins/";

/*----------------------------------------------------------------------
                        Wallet
----------------------------------------------------------------------*/

// Add wallet Hex Fab address or kanban address in the end
const String WithdrawTxStatusApiRoute = 'withdrawrequestsbyaddress/';

// Free Fab
final String getFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/getQuestionair/';
final String postFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/answerQuestionair/';

// USD Coin Price
final String usdCoinPriceUrl =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';

final String allCoinPricesWSRoute = 'allprices';
// Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
final String coinCurrencyUsdValueRoute = 'USDvalues';

// Get App Version
final String getAppVersionRoute = 'getappversion';

// Get Token List, Decimal config, checkstatus
final String getTokenListRoute = 'exchangily/getTokenList';
const String getDecimalPairConfigRoute = 'kanban/getpairconfig';
//final String pairDecimalConfigRoute = 'kanban/getpairconfig';
final String redepositStatusRoute = 'checkstatus/';

/*----------------------------------------------------------------------
                            Exchange
----------------------------------------------------------------------*/

// /ordersbyaddresspaged/:address/:start?/:count?/:status?
// /getordersbytickernamepaged/:address/:tickerName/:start?/:count?/:status?

// Below is the address type which is used in ordersPaged
// convert base58 fab address to hex. trim the first two and last 8 chars.
// then put a 0x in front
final String txStatusStatusRoute = 'kanban/explorer/getTransactionStatus';

final String allPricesWSRoute = 'allPrices';
final String tradesWSRoute = 'trades@';
final String ordersWSRoute = 'orders@';
final String tickerWSRoute = 'ticker@';

final String getOrdersPagedRoute = 'ordersbyaddresspaged/';
final String getOrdersPagedByTickerNameRoute = 'getordersbytickernamepaged/';

/// https://kanbantest.fabcoinapi.com/exchangily/getBalance/
/// 0xb754f9c8b706c59646a4e97601a0ad81067e1cf9/HOT
final String getSingleCoinExchangeBalanceRoute = 'exchangily/getBalance/';
