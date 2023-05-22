import 'package:bitcoin_flutter/bitcoin_flutter.dart' as bitcoin_flutter;
import 'package:exchangilymobileapp/utils/ltc_util.dart';
import 'package:exchangilymobileapp/utils/wallet_coin_address_utils/doge_util.dart';
import 'environment_type.dart';

Map devConfig = {
  "decimal": {'priceDecimal': 6, 'volDecimal': 4},
  "chains": {
    "BTC": {
      "network": bitcoin_flutter.testnet,
      "satoshisPerBytes": 100,
      "bytesPerInput": 152
    },
    "LTC": {
      "network": liteCoinTestnetNetwork,
      "satoshisPerBytes": 400,
      "bytesPerInput": 155
    },
    "BCH": {"testnet": true, "satoshisPerBytes": 9, "bytesPerInput": 155},
    "DOGE": {
      "network": dogeCoinTestnetNetwork,
      "satoshisPerBytes": 800000,
      "bytesPerInput": 152
    },
    "ETH": {
      "chain": 'ropsten',
      "hardfork": 'byzantium',
      "chainId": 5,
      "infura": "https://goerli.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef",
      "gasPrice": 20,
      "gasPriceMax": 200,
      "gasLimit": 21000,
      "gasLimitToken": 70000
    },
    "FAB": {
      "chain": {"name": 'test', "networkId": 212, "chainId": 212},
      "satoshisPerBytes": 100,
      "bytesPerInput": 152,
      "gasPrice": 40,
      "gasLimit": 500000
    },
    "KANBAN": {"chainId": 212, "gasPrice": 50000000, "gasLimit": 20000000}
  },
  "CoinType": {
    "BTC": 1,
    "ETH": 60,
    "FAB": 1150,
    "BCH": 1,
    "LTC": 1,
    "DOGE": 1,
    "TRX": 195
  },
  'endpoints': {
    //for local test
    'blockchaingateLocal': 'http://192.168.0.12:3002/v2/',
    'localKanban': "http://192.168.0.64:4000/",
    //for server
    'blockchaingate': 'https://test.blockchaingate.com/v2/',
    'kanban': 'https://kanbantest.fabcoinapi.com/',
    'HKServer': 'https://api.dscmap.com/',
    'btc': 'https://btctest.fabcoinapi.com/',
    'ltc': 'https://ltctest.fabcoinapi.com/',
    'bch': 'https://bchtest.fabcoinapi.com/',
    'doge': 'https://dogetest.fabcoinapi.com/',
    'fab': 'https://fabtest.fabcoinapi.com/',
    'eth': 'https://ethtest.fabcoinapi.com/',
    'campaign': 'https://test.blockchaingate.com/v2/'
  },
  "addresses": {
    "smartContract": {
      "FABLOCK": '0xa7d4a4e23bf7dd7a1e03eda9eb7c28a016fd54aa',
      "EXG": '0x867480ba8e577402fa44f43c33875ce74bdc5df6',
      "DUSD": '35cb9b675495714909c80c1c11366dc8d396cbe7',
      "USDT": '0xa9f4f6f0fa56058ebdb91865eb2f6aec83b94532',
      "BNB": '0xE90e361892d258F28e3a2E758EEB7E571e370c6f',
      "INB": '0x919c6d21670fe8cEBd1E86a82a1A74E9AA2988F8',
      "REP": '0x4659c4A33432A5091c322E438e0Fb1D286A1EbdE',
      "HOT": '0x6991d9fff5de74085f5c786d425403601280c8f4',
      "CEL": '0xa07a1ab0a8e4d95683dce8d22d0ed665499f0a2b',
      "MATIC": '0x39ccec89a2251652265ab63fdcd551b6f65e37d5',
      "IOST": '0x4dd868d8d961f202e3244a25871105b5e1feaa62',
      "MANA": '0x4527fa0ce6f221a7b9e54412d7a3edd9a37c350a',
      "FUN": '0x98e6affb8192ffd89a62e27dc5a594cd3c1fc8db',
      "WAX": '0xb2140669d08a02b78a9fb4a9ebe36371ae023e5f',
      "ELF": '0xdd3d64919c119a7cde45763b94cf3d1b33fdaff7',
      "GNO": '0x94fd1b18c927935d4f1751239172ad212281f4ac',
      "POWR": '0x6e981f5d973a3ab55ff9db9a77f4123b71d833dd',
      "WINGS": '0x08705dc287150ba2da249b5a1b0c3b99c71b4100',
      "MTL": '0x1c9b5afa112b42b12fb06b62e5f1e159af49dfa7',
      "KNC": '0x3aad796ceb3a1063f727c6d0c698e37053292d10',
      "GVT": '0x3e610d9fb322063e50d185e2cc1b45f007e7180c',
      "DRGN": '0xbbdd7a557a0d8a9bf166dcc2730ae3ccec7df05c',
      "PaycoolReferralAddress": "0xa76af08ba89012e617cd33641f70cb6c2ec957e6"
    },
    'exchangilyOfficial': [
      {'name': 'EXG', 'address': '0xed76be271bb47a6df055bbc2039733c26fdecc82'},
      {'name': 'FAB', 'address': 'n3AYguoFtN7SqsfAJPx6Ky8FTTZUkeKbvc'},
      {'name': 'BTC', 'address': 'n3AYguoFtN7SqsfAJPx6Ky8FTTZUkeKbvc'},
      {'name': 'ETH', 'address': '0x450C53c50F8c0413a5829B0A9ab9Fa7e38f3eD2E'},
      {'name': 'USDT', 'address': '0x450C53c50F8c0413a5829B0A9ab9Fa7e38f3eD2E'},
      {'name': 'DUSD', 'address': '0xed76be271bb47a6df055bbc2039733c26fdecc82'},
      {
        'name': 'BCH',
        'address': 'bchtest:qrkhd038rw685m0s2kauyquhx0pxlhkvsg6dydtwn9 ',
      },
      {'name': 'LTC', 'address': 'n3AYguoFtN7SqsfAJPx6Ky8FTTZUkeKbvc'},
      {'name': 'DOGE', 'address': 'nqqkf8PqJj3CUjwLMEcjJDfpiU5NDcMUrB'}
    ],
  },
  "websocket": {
    "us": "wss://kanbantest.fabcoinapi.com/ws/",
    "hk": "wss://kanbantest.fabcoinapi.com/ws/",
  },
  "minimumWithdraw": {
    "EXG": 50,
    "BTC": 0.02,
    "FAB": 50,
    "ETH": 0.01,
    "USDT": 20,
    "DUSD": 20,
    "BCH": 0.002,
    "LTC": 0.02,
    "DOGE": 20,
    "BNB": 0.6,
    "INB": 20,
    "REP": 0.8,
    "HOT": 16000,
    "CEL": 40,
    "MATIC": 500,
    "IOST": 2000,
    "MANA": 240,
    "FUN": 3000,
    "WAX": 200,
    "ELF": 100,
    "GNO": 0.4,
    "POWR": 100,
    "WINGS": 200,
    "MTL": 40,
    "KNC": 10,
    "GVT": 10,
    "DRGN": 100
  }
};

Map productionConfig = {
  "chains": {
    "BTC": {
      "network": bitcoin_flutter.bitcoin,
      "satoshisPerBytes": 100,
      "bytesPerInput": 152
    },
    "LTC": {
      "network": liteCoinMainnetNetwork,
      "satoshisPerBytes": 400,
      "bytesPerInput": 152
    },
    "BCH": {"testnet": false, "satoshisPerBytes": 9, "bytesPerInput": 155},
    "DOGE": {
      "network": dogeCoinMainnetNetwork,
      "satoshisPerBytes": 800000,
      "bytesPerInput": 152
    },
    "ETH": {
      "chain": 'mainnet',
      "hardfork": 'byzantium',
      "chainId": 1,
      "infura": "https://mainnet.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef",
      "gasPrice": 90,
      "gasPriceMax": 200,
      "gasLimit": 21000,
      "gasLimitToken": 70000
    },
    "FAB": {
      "chain": {
        "name": 'mainnet',
        "networkId": 0,
        "chainId": 0,
      },
      "satoshisPerBytes": 100,
      "bytesPerInput": 152,
      "gasPrice": 40,
      "gasLimit": 500000
    },
    "KANBAN": {"chainId": 211, "gasPrice": 50000000, "gasLimit": 20000000}
  },
  "CoinType": {
    "BTC": 0,
    "ETH": 60,
    "FAB": 1150,
    "BCH": 145,
    "LTC": 2,
    "DOGE": 3,
    "TRX": 195
  },
  'endpoints': {
    'blockchaingate': 'https://www.blockchaingate.com/v2/',
    'kanban': 'https://kanbanprod.fabcoinapi.com/',
    'HKServer': 'https://api.dscmap.com/',
    'btc': 'https://btcprod.fabcoinapi.com/',
    'ltc': 'https://ltcprod.fabcoinapi.com/',
    'bch': 'https://bchprod.fabcoinapi.com/',
    'doge': 'https://dogeprod.fabcoinapi.com/',
    'fab': 'https://fabprod.fabcoinapi.com/',
    'eth': 'https://ethprod.fabcoinapi.com/',
    'trx': 'https://api.trongrid.io/',
    'campaign': 'https://api.blockchaingate.com/v2/'
  },
  'addresses': {
    "smartContract": {
      "FABLOCK": '0x04baa04d9550c49831427c6abe16def2c579af4a',
      "EXG": '0xa3e26671a38978e8204b8a37f1c2897042783b00',
      "USDT": '0xdac17f958d2ee523a2206206994597c13d831ec7',
      "DUSD": '0x46e0021c17d30a2db972ee5719cdc7e829ed9930',
      "BNB": '0xB8c77482e45F1F44dE1745F52C74426C631bDD52',
      "INB": '0x17aa18a4b64a55abed7fa543f2ba4e91f2dce482',
      "REP": '0x1985365e9f78359a9B6AD760e32412f4a445E862',
      "HOT": '0x6c6ee5e31d828de241282b9606c8e98ea48526e2',
      "CEL": '0xaaaebe6fe48e54f431b0c390cfaf0b017d09d42d',
      "MATIC": '0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0',
      "IOST": '0xfa1a856cfa3409cfa145fa4e20eb270df3eb21ab',
      "MANA": '0x0f5d2fb29fb7d3cfee444a200298f468908cc942',
      "FUN": '0x419d0d8bdd9af5e606ae2232ed285aff190e711b',
      "WAX": '0x39bb259f66e1c59d5abef88375979b4d20d98022',
      "ELF": '0xbf2179859fc6d5bee9bf9158632dc51678a4100e',
      "GNO": '0x6810e776880c02933d47db1b9fc05908e5386b96',
      "POWR": '0x595832f8fc6bf59c85c527fec3740a1b7a361269',
      "WINGS": '0x667088b212ce3d06a1b553a7221E1fD19000d9aF',
      "MTL": '0xF433089366899D83a9f26A773D59ec7eCF30355e',
      "KNC": '0xdd974d5c2e2928dea5f71b9825b8b646686bd200',
      "GVT": '0x103c3A209da59d3E7C4A89307e66521e081CFDF0',
      "DRGN": '0x419c4db4b9e25d6db2ad9691ccb832c8d9fda05e',
      "CNB": "ceb9a838c3f3ee6e3168c06734f9188f2693999f",
      "NVZN": "0x99963ee76c886fc43d5063428ff8f926e8a50985",
      "BST": "0x4fe1819daf783a3f3151ea0937090063b85d6122",
      "PaycoolReferralAddress": "0xcd9c20e8e1252d5cd5eacd825e1be2dbda808000",
      "ProjectUserRelation": "0xb16cb516bc0de12e89c7ce6a495012cd00ac2ebf"
    },
    'exchangilyOfficial': [
      {'name': 'EXG', 'address': '0xa7c8257b0571dc3d3c96b24b668c6569391b3ac9'},
      {'name': 'FAB', 'address': '1GJ9cTDJM93Y9Ug443nLix7b9wYyPnad55'},
      {'name': 'BTC', 'address': '1GJ9cTDJM93Y9Ug443nLix7b9wYyPnad55'},
      {'name': 'ETH', 'address': '0x4983f8634255762A18D854790E6d35A522E2633a'},
      {'name': 'USDT', 'address': '0x4983f8634255762A18D854790E6d35A522E2633a'},
      {'name': 'DUSD', 'address': '0xa7c8257b0571dc3d3c96b24b668c6569391b3ac9'},
      {
        'name': 'BCH',
        'address': 'bitcoincash:qznusftmq4cac0fuj6eyke5vv45njxe6eyafcld37l'
      },
      {'name': 'LTC', 'address': 'LaX6sfX8RoHbQHNDEBmdzyBMN9vFa95FXL'},
      {'name': 'DOGE', 'address': 'DLSF9i9weYwpgUrendmuGiHC35HGoHuvR9'},
      {'name': 'TRX', 'address': 'TGfvRWxddNoWrghwE5zC1JEcbXyMdPATdo'}
    ],
    "campaignAddress": {'USDT': '0x4e93c47b42d09f61a31f798877329890791077b2'}
  },
  "websocket": {
    "us": "wss://kanbanprod.fabcoinapi.com/ws/",
    "hk": "wss://api.dscmap.com/ws/",
  },
  "minimumWithdraw": {
    "EXG": 50,
    "BTC": 0.01,
    "FAB": 50,
    "ETH": 0.1 * 2,
    "USDT": 20 * 2,
    "DUSD": 20,
    "BCH": 0.002,
    "LTC": 0.02,
    "DOGE": 20,
    "BNB": 0.6 * 2,
    "INB": 20 * 2,
    "REP": 0.8 * 2,
    "HOT": 16000 * 2,
    "CEL": 40 * 2,
    "MATIC": 500 * 2,
    "IOST": 2000 * 2,
    "MANA": 240 * 2,
    "FUN": 3000 * 2,
    "WAX": 200 * 2,
    "ELF": 100 * 2,
    "GNO": 0.4 * 2,
    "POWR": 100 * 2,
    "WINGS": 200 * 2,
    "MTL": 40 * 2,
    "KNC": 10 * 2,
    "GVT": 10 * 2,
    "DRGN": 100 * 2
  }
};

final environment = isProduction ? productionConfig : devConfig;
