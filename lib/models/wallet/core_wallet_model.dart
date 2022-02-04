/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

class CoreWalletModel {
  int id;
  String mnemonic;
  String walletBalancesBody;

  CoreWalletModel({this.id, this.mnemonic, this.walletBalancesBody});

  factory CoreWalletModel.fromJson(Map<String, dynamic> json) {
    return CoreWalletModel(
      id: json['id'],
      mnemonic: json['mnemonic'] as String,
      walletBalancesBody: json['walletBalancesBody'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mnemonic'] = mnemonic;
    data['walletBalancesBody'] = walletBalancesBody;

    return data;
  }
}

//