import 'package:decimal/decimal.dart';

class Constants {
  static Pattern regexPattern = r'^(0|(\d+)|\.(\d+))(\.(\d+))?$';
  static Map<String, String> headersText = {"responseType;": "text"};
  static Map<String, String> headersJson = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static int tronUsdtFee = 40;
  static int tronFee = 1;
  static Decimal decimalZero = Decimal.zero;
  static const String baseAssetImagesLocalPath = 'assets/images/';

  static const String dollarSignImageLocalUrl =
      '${baseAssetImagesLocalPath}wallet-page/dollar-sign.png';
  static const String walletBackgroundLocalUrl =
      '${baseAssetImagesLocalPath}wallet-page/background.png';
  static const String excahngilyLogoLocalUrl =
      '${baseAssetImagesLocalPath}wallet-page/exlogo.png';

  static const String emptyWalletLocalUrl =
      '${baseAssetImagesLocalPath}icons/wallet_empty.png';

  static const String customTokenLogoLocalUrl =
      '${baseAssetImagesLocalPath}icons/custom-token-logo.png';

  static const List<String> specialTokens = [
    'USDTX',
    'FABE',
    'EXGE',
    'DSCE',
    'BSTE',
    'USDTB',
    'FABB',
    'USDTM',
    'MATICM'
  ];

  static const String appName = 'exchangily';
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

  static const String fabChainPrefix = '0002';
  static const String ethChainPrefix = '0003';
  static const String tronChainPrefix = '0007';
  static const String bnbChainPrefix = '0008';
  static const String maticmChainPrefix = '0009';

  static const String DepositSignatureAbi = "0x379eb862";
  static const String WithdrawSignatureAbi = "0x3295d51e";
  static const String SendSignatureAbi = "0x3faf0a66";
  static const String CustomTokenSignatureAbi = "70a08231";
  static const String unlockAbiSignature = "0x27978c85";
  static const String lockAbiSignature = "0xe98bfea0";

// tron
  static const String DepositTronUsdtSignatureAbi = 'a9059cbb';
  static const String DepositTronTypeProtocol = "type.googleapis.com/protocol.";

  static const String EthMessagePrefix = '\u0019Ethereum Signed Message:\n';
  static const String BtcMessagePrefix = '\x18Bitcoin Signed Message:\n';

  static const String ISRG_X1 = """-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----""";

  static String ImportantWalletUpdateText =
      'Invalid password: If you fill the valid password then please delete the current wallet in Settings and then re-import, to use the latest wallet';
}
