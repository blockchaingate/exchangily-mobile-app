import 'package:bs58check/bs58check.dart' as bs58check;
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

var Format = {'Legacy': 'legacy', 'Kbpay': 'kbpay'};

var Network = {'Mainnet': 'mainnet', 'Testnet': 'testnet'};

var Type = {'P2PKH': 'p2pkh'};

isValidAddress(input) {
  try {
    decodeAddress(input);
    return true;
  } catch (error) {
    return false;
  }
}

detectAddressFormat(address) {
  return decodeAddress(address)['format'];
}

detectAddressNetwork(address) {
  return decodeAddress(address)['network'];
}

detectAddressType(address) {
  return decodeAddress(address)['type'];
}

toLegacyAddressDecode(address) {
  var decoded = decodeAddress(address);
  return decoded;
}

toLegacyAddress(address) {
  var decoded = decodeAddress(address);
  if (decoded['format'] == Format['Legacy']) {
    return '';
  }
  return encodeAsLegacy(decoded);
}

toKbpayAddress(address) {
  var decoded = decodeAddress(address);

  debugPrint('decoded=');
  debugPrint(decoded.toString());
  if (decoded['format'] == Format['Kbpay']) {
    return address;
  }
  return encodeAsKbpay(decoded);
}

var VERSION_BYTE = {
  Format['Legacy']: {
    Network['Mainnet']: {Type['P2PKH']: 0},
    Network['Testnet']: {Type['P2PKH']: 111}
  },
  Format['Kbpay']: {
    Network['Mainnet']: {Type['P2PKH']: 46},
    Network['Testnet']: {Type['P2PKH']: 115}
  }
};

decodeAddress(address) {
  try {
    return decodeBase58Address(address);
  } catch (err) {
    debugPrint('decodeAddress - CATCH: $err');
  }
  return '';
}

var BASE_58_CHECK_PAYLOAD_LENGTH = 21;

decodeBase58Address(address) {
  try {
    debugPrint('address=' + address);
    var payload = bs58check.decode(address);
    debugPrint('payload=');
    debugPrint(payload.toString());
    if (payload.length != BASE_58_CHECK_PAYLOAD_LENGTH) {
      return '';
    }
    var versionByte = payload[0];
    var hash = payload.sublist(1);

    debugPrint('versionByte===');
    debugPrint(versionByte.toString());
    if (versionByte ==
        VERSION_BYTE[Format['Legacy']]![Network['Mainnet']]![Type['P2PKH']]) {
      return {
        'hash': hash,
        'format': Format['Legacy'],
        'network': Network['Mainnet'],
        'type': Type['P2PKH']
      };
    } else if (versionByte ==
        VERSION_BYTE[Format['Legacy']]![Network['Testnet']]![Type['P2PKH']]) {
      debugPrint('go this way');
      return {
        'hash': hash,
        'format': Format['Legacy'],
        'network': Network['Testnet'],
        'type': Type['P2PKH']
      };
    }

    if (versionByte ==
        VERSION_BYTE[Format['Kbpay']]![Network['Mainnet']]![Type['P2PKH']]) {
      return {
        'hash': hash,
        'format': Format['Kbpay'],
        'network': Network['Mainnet'],
        'type': Type['P2PKH']
      };
    } else if (versionByte ==
        VERSION_BYTE[Format['Kbpay']]![Network['Testnet']]![Type['P2PKH']]) {
      return {
        'hash': hash,
        'format': Format['Kbpay'],
        'network': Network['Testnet'],
        'type': Type['P2PKH']
      };
    }
  } catch (err) {
    debugPrint('decodeBase58Address - CATCH: $err');
  }
  return {};
}

encodeAsLegacy(decoded) {
  var versionByte =
      VERSION_BYTE[Format['Legacy']]![decoded['network']]![decoded['type']]!;
  var buffer = Uint8List(decoded['hash'].length + 1);
  buffer[0] = versionByte;
  for (var i = 0; i < decoded['hash'].length; i++) {
    buffer[i + 1] = decoded['hash'][i];
  }
  // buffer.set(decoded.hash, 1);
  return bs58check.encode(buffer);
}

encodeAsKbpay(decoded) {
  debugPrint('decoded=');
  debugPrint(decoded.toString());
  var versionByte =
      VERSION_BYTE[Format['Kbpay']]![decoded['network']]![decoded['type']]!;

  //var buffer = Uint8List.fromList(decoded['hash']);
  var buffer = Uint8List(decoded['hash'].length + 1);
  buffer[0] = versionByte;
  for (var i = 0; i < decoded['hash'].length; i++) {
    buffer[i + 1] = decoded['hash'][i];
  }
  debugPrint('buffer in encodeAsKbpay=');
  debugPrint(buffer.toString());
  return bs58check.encode(buffer);
}

isLegacyAddress(address) {
  return detectAddressFormat(address) == Format['Legacy'];
}

isKbpayAddress(address) {
  return detectAddressFormat(address) == Format['Kbpay'];
}

isMainnetAddress(address) {
  return detectAddressNetwork(address) == Network['Mainnet'];
}

isTestnetAddress(address) {
  return detectAddressNetwork(address) == Network['Testnet'];
}

isP2PKHAddress(address) {
  return detectAddressType(address) == Type['P2PKH'];
}
