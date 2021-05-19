import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';

/*----------------------------------------------------------------------
                        Base Url's
----------------------------------------------------------------------*/

const String baseBlockchainGateV2Url = isProduction
    ? 'https://api.blockchaingate.com/v2/'
    : 'https://test.blockchaingate.com/v2/';

const String TronBaseApiUrl = 'https://api.trongrid.io/';
/*----------------------------------------------------------------------
                        Bindpay
----------------------------------------------------------------------*/
const String ChargeTextApiRoute = "charge";
const String OrdersTextApiRoute = "orders";
const String PayOrderApiRoute = OrdersTextApiRoute + "/code/";

/*----------------------------------------------------------------------
                        Wallet
----------------------------------------------------------------------*/
const String KanbanApiRoute = 'kanban/';
const String GetScarAddressApiRoute = 'getScarAddress';
const String GetTransactionCountApiRoute = 'getTransactionCount/';
const String GetBalanceApiRoute = 'getBalance/';
const String ResubmitDepositApiRoute = 'resubmitDeposit';
const String SendRawTxApiRoute = 'sendRawTransaction';
const String DepositerrApiRoute = 'depositerr/';
const String SubmitDepositApiRoute = 'submitDeposit';

const String TronUsdtAccountBalanceUrl =
    TronBaseApiUrl + "wallet/triggerconstantcontract";
const String TronGetAccountUrl = TronBaseApiUrl + "wallet/getaccount";
//  const requestURL = `${TRON_API_ENDPOINT}/wallet/getaccount`;
// const requestBody = {
//   address,
//   visible: true
// };

const String BroadcasrTronTransactionUrl =
    TronBaseApiUrl + "wallet/broadcasthex";
const String GetTronLatestBlockUrl = TronBaseApiUrl + 'wallet/getnowblock';

const String WalletBalancesApiRoute = 'walletBalances';
const String SingleWalletBalanceApiRoute = 'singleCoinWalletBalance';
const String WalletCoinsLogoUrl = "https://www.exchangily.com/assets/coins/";

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

// Free Fab
final String getFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/getQuestionair/';
final String postFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/answerQuestionair/';

// USD Coin Price
const String GetUsdCoinPriceUrl =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';

// Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
const String CoinCurrencyUsdValueApiRoute = 'USDvalues';

// Get App Version
const String GetAppVersionRoute = 'getappversion';

// Get Token List, Decimal config, checkstatus
const String GetTokenListApiRoute = 'exchangily/getTokenList';
const String GetDecimalPairConfigApiRoute = 'kanban/getpairconfig';
//final String pairDecimalConfigRoute = 'kanban/getpairconfig';
const String WithDrawDepositTxHistoryApiRoute = 'getTransactionHistoryEvents';
// route for getting history for withdraw and deposits
const String BindpayTxHHistoryApiRoute = 'getTransferHistoryEvents';
// route for bindpay transfers

const String RedepositCheckStatusApiRoute = 'checkstatus/';
// Add wallet Hex Fab address or kanban address in the end
const String WithdrawTxStatusApiRoute = 'withdrawrequestsbyaddress/';
const String DepositTxStatusApiRoute = 'getdepositrequestsbyaddress/';

const String GetUtxosApiRoute = 'getutxos/';
const String GetNonceApiRoute = 'getnonce/';
const String PostRawTxApiRoute = 'postrawtransaction';
const String GetTokenListUpdatesApiRoute = 'tokenListUpdates';

/*----------------------------------------------------------------------
                            Exchange
----------------------------------------------------------------------*/

// banner
const String BannerApiUrl =
    'https://api.blockchaingate.com/v2/banners/app/5b6a8688905612106e976a69';

// /ordersbyaddresspaged/:address/:start?/:count?/:status?
// /getordersbytickernamepaged/:address/:tickerName/:start?/:count?/:status?

// Below is the address type which is used in ordersPaged
// convert base58 fab address to hex. trim the first two and last 8 chars.
// then put a 0x in front

final String btcBaseUrl = environment["endpoints"]["btc"];
final String ltcBaseUrl = environment["endpoints"]["ltc"];
final String bchBaseUrl = environment["endpoints"]["bch"];
final String dogeBaseUrl = environment["endpoints"]["doge"];
final String fabBaseUrl = environment["endpoints"]["fab"];
final String ethBaseUrl = environment["endpoints"]["eth"];
final String eventsUrl = environment["eventInfo"];

final String txStatusStatusRoute = 'kanban/explorer/getTransactionStatus';

// Websockets

const String AllPricesWSRoute = 'allPrices';
const String TradesWSRoute = 'trades@';
const String OrdersWSRoute = 'orders@';
const String TickerWSRoute = 'ticker@';

// My Orders

const String GetOrdersByAddrApiRoute = 'ordersbyaddresspaged/';
const String GetOrdersByTickerApiRoute = 'getordersbytickernamepaged/';

// Exchange Balance

/// https://kanbantest.fabcoinapi.com/exchangily/getBalance/
/// 0xb754f9c8b706c59646a4e97601a0ad81067e1cf9/HOT
const String GetSingleCoinExchangeBalApiRoute = 'exchangily/getBalance/';
const String AssetsBalanceApiRoute = 'exchangily/getBalances/';

const String OrdersByAddrApiRoute = 'ordersbyaddress/';
