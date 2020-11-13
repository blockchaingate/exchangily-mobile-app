class Constants {

/*----------------------------------------------------------------------
                        Campaign
----------------------------------------------------------------------*/
  static const String testUsdtWalletAddress =
      '0x7bfbfaf1d3f81827e1642114c7905de413d83321';
  static const String prodUsdtWalletAddress =
      '0x4e93c47b42d09f61a31f798877329890791077b2';

/*----------------------------------------------------------------------
                        Exchange
----------------------------------------------------------------------*/

// String key = intervalMap.keys.elementAt(index)
// Value = intervalMap[key]
  static const Map<String, String> intervalMap = {
    '1min': '1m',
    '5min': '5m',
    '30min': '30m',
    '1HR': '1h',
    '4HR': '4h',
    '1D': '24h',
  };
}
