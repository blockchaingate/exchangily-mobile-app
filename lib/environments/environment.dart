import 'package:bitcoin_flutter/src/models/networks.dart';

const bool isProduction = false;
const bool isLocal = true;
Map devConfig = {
  "chains": {
    "BTC": {"network": testnet, "satoshisPerBytes": 34, "bytesPerInput": 150},
    "ETH": {
      "chain": 'ropsten',
      "hardfork": 'byzantium',
      "chainId": 3,
      "infura": "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef",
      "gasPrice": 6000000000,
      "gasLimit": 100000
    },
    "FAB": {
      "chain": {"name": 'test', "networkId": 212, "chainId": 212},
      "satoshisPerBytes": 14,
      "bytesPerInput": 150,
      "gasPrice": 50,
      "gasLimit": 800000
    },
    "KANBAN": {"chainId": 212, "gasPrice": 8000000000, "gasLimit": 20000000}
  },
  "CoinType": {"BTC": 1, "ETH": 60, "FAB": 1150},
  'endpoints': {
    'kanban': 'https://kanbantest.fabcoinapi.com/',
    'btc': 'https://btctest.fabcoinapi.com/',
    'fab': 'https://fabtest.fabcoinapi.com/',
    'eth': 'https://ethtest.fabcoinapi.com/'
  },
  "addresses": {
    "smartContract": {
      "FABLOCK": '0xa7d4a4e23bf7dd7a1e03eda9eb7c28a016fd54aa',
      "EXG": '0x867480ba8e577402fa44f43c33875ce74bdc5df6',
      "USDT": '0x1c35eCBc06ae6061d925A2fC2920779a1896282c',
    },
    'exchangilyOfficial': [
      {'name': 'EXG', 'address': '0xdcd0f23125f74ef621dfa3310625f8af0dcd971b'},
      {'name': 'FAB', 'address': 'n1eXG5oe6wJ6h43akutyGfphqQsY1UfAUR'},
      {'name': 'BTC', 'address': 'muQDw5hVmFgD1GrrWvUt6kjrzauC4Msaki'},
      {'name': 'ETH', 'address': '0x02c55515e62a0b25d2447c6d70369186b8f10359'},
      {'name': 'USDT', 'address': '0x02c55515e62a0b25d2447c6d70369186b8f10359'}
    ]
  },
  "websocket": "wss://kanbantest.fabcoinapi.com/ws/",
  "minimumWithdraw": {
    "EXG": 10,
    "BTC": 0.002,
    "FAB": 0.005,
    "ETH": 0.01,
    "USDT": 10
  }
};

Map productionConfig = {
  "chains": {
    "BTC": {"network": bitcoin, "satoshisPerBytes": 34, "bytesPerInput": 150},
    "ETH": {
      "chain": 'mainnet',
      "hardfork": 'byzantium',
      "chainId": 1,
      "infura": "https://mainnet.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef",
      "gasPrice": 6000000000,
      "gasLimit": 100000
    },
    "FAB": {
      "chain": {
        "name": 'mainnet',
        "networkId": 0,
        "chainId": 0,
        "satoshisPerBytes": 14,
        "bytesPerInput": 150,
        "gasPrice": 50,
        "gasLimit": 800000
      }
    },
    "KANBAN": {"chainId": 211, "gasPrice": 8000000000, "gasLimit": 20000000}
  },
  "CoinType": {"BTC": 0, "ETH": 60, "FAB": 1150},
  'endpoints': {
    'kanban': 'https://kanbanprod.fabcoinapi.com/',
    'btc': 'https://btcprod.fabcoinapi.com/',
    'fab': 'https://fabprod.fabcoinapi.com/',
    'eth': 'https://ethprod.fabcoinapi.com/'
  },
  'addresses': {
    "smartContract": {
      "FABLOCK": '0x04baa04d9550c49831427c6abe16def2c579af4a',
      "EXG": '0xa3e26671a38978e8204b8a37f1c2897042783b00',
      "USDT": '0xdac17f958d2ee523a2206206994597c13d831ec7',
    },
    'exchangilyOfficial': [
      {'name': 'EXG', 'address': '0x9d95ee21e4f1b05bbfd0094daf4ce110deb00931'},
      {'name': 'FAB', 'address': '1FNEhT8uTmrEMvHGCGohnEFv6Q1z4qRhQu'},
      {'name': 'BTC', 'address': '1CKg6irbGXHxBHuTx7MeqYQUuMZ8aEok8z'},
      {'name': 'ETH', 'address': '0xe7721493eea554b122dfd2c6243ef1c6f2fe0a06'},
      {'name': 'USDT', 'address': '0xe7721493eea554b122dfd2c6243ef1c6f2fe0a06'}
    ]
  },
  "websocket": "wss://kanbanprod.fabcoinapi.com/ws/",
  "minimumWithdraw": {
    "EXG": 10,
    "BTC": 0.01,
    "FAB": 0.01,
    "ETH": 0.01,
    "USDT": 10
  }
};

final environment = isProduction ? productionConfig : devConfig;
