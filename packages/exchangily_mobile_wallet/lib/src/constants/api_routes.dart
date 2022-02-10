/*----------------------------------------------------------------------
                        Base Url's
----------------------------------------------------------------------*/

import 'package:exchangily_mobile_wallet/src/environments/environment_type.dart';

const String baseBlockchainGateV2Url = isProduction
    ? 'https://api.blockchaingate.com/v2/'
    : 'https://test.blockchaingate.com/v2/';

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
const String exchangilyExplorerUrl =
    "https://exchangily.com/explorer/tx-detail/";
const String bitcoinExplorerUrl = "https://live.blockcypher.com/btc/tx/";
const String ethereumExplorerUrl = "https://etherscan.io/tx/";
const String testnetEthereumExplorerUrl = "https://ropsten.etherscan.io/tx/";
const String fabExplorerUrl = "https://fabexplorer.info/#/transactions/";
const String litecoinExplorerUrl = "https://live.blockcypher.com/ltx/tx/";
const String dogeExplorerUrl = "https://dogechain.info/tx/";
const String bitcoinCashExplorerUrl = "https://explorer.bitcoin.com/bch/tx/";
const String tronExplorerUrl = "https://tronscan.org/#/transaction/";

// Free Fab
const String getFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/getQuestionair/';
const String postFreeFabUrl =
    baseBlockchainGateV2Url + 'airdrop/answerQuestionair/';

// USD Coin Price
const String getUsdCoinPriceUrl =
    'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';

// Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
const String coinCurrencyUsdValueApiRoute = 'USDvalues';

// Get App Version
const String getAppVersionRoute = 'getappversion';

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
