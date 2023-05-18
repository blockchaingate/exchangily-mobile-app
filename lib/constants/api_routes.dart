import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';

/*----------------------------------------------------------------------
                        Base Url's
----------------------------------------------------------------------*/

const String baseBlockchainGateV2Url = isProduction
    ? 'https://api.blockchaingate.com/v2/'
    : 'https://test.blockchaingate.com/v2/';

const String fabInfoUrl =
    isProduction ? 'https://fabprod.info/' : 'https://fabtest.info/';

const String tronBaseApiUrl = 'https://api.trongrid.io/';

/*----------------------------------------------------------------------
                        LightningRemit
----------------------------------------------------------------------*/
const String chargeTextApiRoute = "charge";
const String ordersTextApiRoute = "orders";
const String payOrderApiRoute = ordersTextApiRoute + "/code/";

/*----------------------------------------------------------------------
                        Wallet
----------------------------------------------------------------------*/

const String exchangilyPrivacyUrl = "https://www.exchangily.com/privacy";

const String appVersionUrl =
    "https://api.coinranklist.com/app-update/exchangily-app-version";
const String maticGasFeeUrl = "https://gasstation-mumbai.matic.today/v2";
const String exchangilyAppLatestApkUrl =
    'http://exchangily.com/download/latest.apk';
// app update post
const String postAppUpdateVersionUrl =
    "http://52.194.202.239:3000/app-update/set-version-info";

const String fabTransactionJsonApiRoute = 'gettransactionjson/';

const String kanbanApiRoute = 'kanban/';
const String getScarAddressApiRoute = 'getScarAddress';
const String getTransactionCountApiRoute = 'getTransactionCount/';
const String getBalanceApiRoute = 'getBalance/';
const String resubmitDepositApiRoute = 'resubmitDeposit';
const String sendRawTxApiRoute = 'sendRawTransaction';
const String depositerrApiRoute = 'depositerr/';
const String submitDepositApiRoute = 'submitDeposit';

const String tronUsdtAccountBalanceUrl =
    tronBaseApiUrl + "wallet/triggerconstantcontract";
const String tronGetAccountUrl = tronBaseApiUrl + "wallet/getaccount";
//  const requestURL = `${TRON_API_ENDPOINT}/wallet/getaccount`;
// const requestBody = {
//   address,
//   visible: true
// };

const String broadcasrTronTransactionUrl =
    tronBaseApiUrl + "wallet/broadcasthex";
const String getTronLatestBlockUrl = tronBaseApiUrl + 'wallet/getnowblock';

const String walletBalancesApiRoute = 'walletBalances';
const String singleWalletBalanceApiRoute = 'singleCoinWalletBalance';
const String walletCoinsLogoUrl = "https://www.exchangily.com/assets/coins/";

// Transaction history explorer URL's for prod
const String ExchangilyExplorerUrl =
    "https://exchangily.com/explorer/tx-detail/";
const String BitcoinExplorerUrl = "https://live.blockcypher.com/btc/tx/";
const String EthereumExplorerUrl = "https://etherscan.io/tx/";
const String TestnetEthereumExplorerUrl = "https://ropsten.etherscan.io/tx/";
const String FabExplorerUrl = "https://fabexplorer.info/#/transactions/";
const String LitecoinExplorerUrl = "https://live.blockcypher.com/ltx/tx/";
const String DogeExplorerUrl = "https://dogechain.info/tx/";
const String BitcoinCashExplorerUrl = "https://explorer.bitcoin.com/bch/tx/";
const String TronExplorerUrl = "https://tronscan.org/#/transaction/";
// testnet.bscscan.com
const String bnbExplorerUrl = 'https://www.bscscan.com/tx/';
const String maticmExplorerUrl = 'https://polygonscan.com/tx/';

// Free Fab
const String getFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/getQuestionair/';
const String postFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/answerQuestionair/';

// USD Coin Price
const String GetUsdCoinPriceUrl =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';

// Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
const String CoinCurrencyUsdValueApiRoute = 'USDvalues';

// Get App Version
const String GetAppVersionRoute = 'getappversion';

// Get Token List, Decimal config, checkstatus
const String getTokenListApiRoute = 'exchangily/getTokenList';
const String getDecimalPairConfigApiRoute = 'kanban/getpairconfig';
//final String pairDecimalConfigRoute = 'kanban/getpairconfig';
const String withDrawDepositTxHistoryApiRoute = 'getTransactionHistoryEvents';
// route for getting history for withdraw and deposits
const String lightningRemitTxHHistoryApiRoute = 'getTransferHistoryEvents';
// route for bindpay transfers

const String redepositCheckStatusApiRoute = 'checkstatus/';
// Add wallet Hex Fab address or kanban address in the end
const String withdrawTxStatusApiRoute = 'withdrawrequestsbyaddress/';
const String depositTxStatusApiRoute = 'getdepositrequestsbyaddress/';

const String getUtxosApiRoute = 'getutxos/';
const String getNonceApiRoute = 'getnonce/';
const String postRawTxApiRoute = 'postrawtransaction';
const String getTokenListUpdatesApiRoute = 'tokenListUpdates';

// wallet custom issue token feature url and routes

// get all tokens without logo
// https://test.blockchaingate.com/v2/issuetoken/withoutLogo

// get single token without logo
//https://test.blockchaingate.com/v2/issuetoken/ca83824ad8abcc4d03a9d2209bcd8efddff2615c/withoutLogo

// get token's logo
//https://test.blockchaingate.com/v2/issuetoken/ca83824ad8abcc4d03a9d2209bcd8efddff2615c/logo
const String getIsueTokenApiRoute = 'issuetoken';
const String getWithoutLogoApiRoute = 'withoutLogo';
const String getLogoApiRoute = 'withoutLogo';

/*----------------------------------------------------------------------
                            Exchange
----------------------------------------------------------------------*/

// banner
const String bannerApiUrl =
    'https://api.blockchaingate.com/v2/banners/app/5b6a8688905612106e976a69';

// https://fabtest.info/api/kanban/locker/user/0xdcd0f23125f74ef621dfa3310625f8af0dcd971b/50/0
const String lockerApiUrl = fabInfoUrl + 'api/kanban/locker/user/';
const String totalCountTextApiRoute = '/totalCount';

// /ordersbyaddresspaged/:address/:start?/:count?/:status?
// /getordersbytickernamepaged/:address/:tickerName/:start?/:count?/:status?

// Below is the address type which is used in ordersPaged
// convert base58 fab address to hex. trim the first two and last 8 chars.
// then put a 0x in front

final String? btcBaseUrl = environment["endpoints"]["btc"];
final String? ltcBaseUrl = environment["endpoints"]["ltc"];
final String? bchBaseUrl = environment["endpoints"]["bch"];
final String? dogeBaseUrl = environment["endpoints"]["doge"];
final String? fabBaseUrl = environment["endpoints"]["fab"];
final String? ethBaseUrl = environment["endpoints"]["eth"];
final String? maticmBaseUrl = environment["endpoints"]["maticm"];
final String? bnbBaseUrl = environment["endpoints"]["bnb"];
final String? eventsUrl = environment["eventInfo"];

const String txStatusStatusRoute = 'kanban/explorer/getTransactionStatus';

// Websockets

const String allPricesWSRoute = 'allPrices';
const String tradesWSRoute = 'trades@';
const String ordersWSRoute = 'orders@';
const String tickerWSRoute = 'ticker@';

// My Orders

const String getOrdersByAddrApiRoute = 'ordersbyaddresspaged/';
const String getOrdersByTickerApiRoute = 'getordersbytickernamepaged/';

// Exchange Balance

/// https://kanbantest.fabcoinapi.com/exchangily/getBalance/
/// 0xb754f9c8b706c59646a4e97601a0ad81067e1cf9/HOT
const String getSingleCoinExchangeBalApiRoute = 'exchangily/getBalance/';
const String assetsBalanceApiRoute = 'exchangily/getBalances/';

const String ordersByAddrApiRoute = 'ordersbyaddress/';

// Events

const String exchangilyBlogUrl = "https://blog.exchangily.com/";

const String exchangilyAnnouncementUrl =
    "https://exchangily.com/announcements/";
