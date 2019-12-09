

const bool isProduction = false;

var devConfig = {

  "chains": {
    "ETH": {
      "chain": 'ropsten',
      "hardfork": 'byzantium',
      "web3Provider": 'https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef'
    },
    "FAB": {
      "chain": {
        "name": 'test',
        "networkId": 212,
        "chainId": 212
      }
    }
  },
  "CoinType": {
    "BTC": 1,
    "ETH": 60,
    "FAB": 1150
  },
  'endpoints': {
    'kanban': 'https://kanbantest.fabcoinapi.com/',
    'btc': 'https://btctest.fabcoinapi.com/',
    'fab': 'https://fabtest.fabcoinapi.com/',
    'eth': 'https://ethtest.fabcoinapi.com/'
  },
  "addresses": {
    "smartContract": {
      "FABLOCK": '0xa7d4a4e23bf7dd7a1e03eda9eb7c28a016fd54aa',
      "EXG": '0x311acf4666477a22c2f16c53b88c1734ee227fc6',
      "USDT": '0x1c35eCBc06ae6061d925A2fC2920779a1896282c',
    },

    'exchangilyOfficial': [
      {
        'name':'EXG',
        'address':'0xdcd0f23125f74ef621dfa3310625f8af0dcd971b'
      },
      {
        'name':'FAB',
        'address':'n1eXG5oe6wJ6h43akutyGfphqQsY1UfAUR'
      },
      {
        'name':'BTC',
        'address':'muQDw5hVmFgD1GrrWvUt6kjrzauC4Msaki'
      },
      {
        'name':'ETH',
        'address':'0x02c55515e62a0b25d2447c6d70369186b8f10359'
      },
      {
        'name':'USDT',
        'address':'0x02c55515e62a0b25d2447c6d70369186b8f10359'
      }
    ]
  }
};

var productionConfig = {
  "chains": {
    "ETH": {
      "chain": 'mainnet',
      "hardfork": 'byzantium',
      "web3Provider": 'https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef'
    },
    "FAB": {
      "chain": {
        "name": 'mainnet',
        "networkId": 0,
        "chainId": 0
      }
    }
  },
  "CoinType": {
    "BTC": 0,
    "ETH": 60,
    "FAB": 1150
  },
  'endpoints': {
    'kanban': 'https://kanbantest.fabcoinapi.com/',
    'btc': 'https://btctest.fabcoinapi.com/',
    'fab': 'https://fabtest.fabcoinapi.com/',
    'eth': 'https://ethtest.fabcoinapi.com/'
  },
  'addresses': {
    "smartContract": {
      "FABLOCK": '0x04baa04d9550c49831427c6abe16def2c579af4a',
      "EXG": '0xa3e26671a38978e8204b8a37f1c2897042783b00',
      "USDT": '0xdac17f958d2ee523a2206206994597c13d831ec7',
    },
    'exchangilyOfficial': [
      {
        'name':'EXG',
        'address':'0xdcd0f23125f74ef621dfa3310625f8af0dcd971b'
      },
      {
        'name':'FAB',
        'address':'n1eXG5oe6wJ6h43akutyGfphqQsY1UfAUR'
      },
      {
        'name':'BTC',
        'address':'muQDw5hVmFgD1GrrWvUt6kjrzauC4Msaki'
      },
      {
        'name':'ETH',
        'address':'0x02c55515e62a0b25d2447c6d70369186b8f10359'
      },
      {
        'name':'USDT',
        'address':'0x02c55515e62a0b25d2447c6d70369186b8f10359'
      }
    ]
  }
};

final environment = isProduction ? productionConfig : devConfig;