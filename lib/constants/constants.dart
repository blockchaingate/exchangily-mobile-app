import 'package:exchangilymobileapp/environments/environment_type.dart';

class Constants {
  static const String BASE_KANBAN_PROD_URL =
      'https://kanbanprod.fabcoinapi.com/';
  static const String BASE_KANBAN_TEST_URL =
      'https://kanbantest.fabcoinapi.com/';
  static const String COIN_PRICE_WS_URL =
      'wss://kanbanprod.fabcoinapi.com/ws/allprices';
  static const String testUsdtWalletAddress =
      '0x7bfbfaf1d3f81827e1642114c7905de413d83321';
  static const String prodUsdtWalletAddress =
      '0x4e93c47b42d09f61a31f798877329890791077b2';
  // Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
  static const COIN_CURRENCY_USD_PRICE_URL =
      'https://kanbanprod.fabcoinapi.com/USDvalues';
  static const String PAIR_DECIMAL_CONFIG_URL =
      (isProduction ? BASE_KANBAN_PROD_URL : BASE_KANBAN_TEST_URL) +
          'kanban/getpairconfig';
  static const REDEPOSIT_STATUS_URL =
      'https://kanbantest.fabcoinapi.com/checkstatus/';
}
