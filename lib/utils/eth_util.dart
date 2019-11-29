import 'package:keccak/keccak.dart';
import "string_util.dart";
getTransactionHash(String txHex) {

  /*
  input:
  f86c4f8502540be4008252089402c55515e62a0b25d2447c6d70369186b8f103598801aa535d3d0c0000802aa0da719ae9c04a8717f3b161430f3e4beb877dcc4c985d8184cad26251a09a2284a04dd5813739731a5d7c54f0fd620b12017d0409508d41166fbf622c38333b2af6
  expected output:
  0x86b43cb98c10dbb6474ca495d1939cb0526ad696adde2636f3c1500b2ba52a58

   */
  //txHex="f86c4f8502540be4008252089402c55515e62a0b25d2447c6d70369186b8f103598801aa535d3d0c0000802aa0da719ae9c04a8717f3b161430f3e4beb877dcc4c985d8184cad26251a09a2284a04dd5813739731a5d7c54f0fd620b12017d0409508d41166fbf622c38333b2af6";
  //print('txHex=');
  //print(txHex);
  txHex = trimHexPrefix(txHex);
  var p = keccak(stringToUint8List(txHex));
  var hash = "0x" + uint8ListToString(p);
  return hash;
}