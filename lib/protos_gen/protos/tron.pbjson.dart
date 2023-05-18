///
//  Generated code. Do not modify.
//  source: protos/tron.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use transferContractDescriptor instead')
const TransferContract$json = const {
  '1': 'TransferContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'to_address', '3': 2, '4': 1, '5': 12, '10': 'toAddress'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `TransferContract`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferContractDescriptor = $convert.base64Decode('ChBUcmFuc2ZlckNvbnRyYWN0EiMKDW93bmVyX2FkZHJlc3MYASABKAxSDG93bmVyQWRkcmVzcxIdCgp0b19hZGRyZXNzGAIgASgMUgl0b0FkZHJlc3MSFgoGYW1vdW50GAMgASgDUgZhbW91bnQ=');
@$core.Deprecated('Use transferAssetContractDescriptor instead')
const TransferAssetContract$json = const {
  '1': 'TransferAssetContract',
  '2': const [
    const {'1': 'asset_name', '3': 1, '4': 1, '5': 12, '10': 'assetName'},
    const {'1': 'owner_address', '3': 2, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'to_address', '3': 3, '4': 1, '5': 12, '10': 'toAddress'},
    const {'1': 'amount', '3': 4, '4': 1, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `TransferAssetContract`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferAssetContractDescriptor = $convert.base64Decode('ChVUcmFuc2ZlckFzc2V0Q29udHJhY3QSHQoKYXNzZXRfbmFtZRgBIAEoDFIJYXNzZXROYW1lEiMKDW93bmVyX2FkZHJlc3MYAiABKAxSDG93bmVyQWRkcmVzcxIdCgp0b19hZGRyZXNzGAMgASgMUgl0b0FkZHJlc3MSFgoGYW1vdW50GAQgASgDUgZhbW91bnQ=');
@$core.Deprecated('Use triggerSmartContractDescriptor instead')
const TriggerSmartContract$json = const {
  '1': 'TriggerSmartContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'contract_address', '3': 2, '4': 1, '5': 12, '10': 'contractAddress'},
    const {'1': 'call_value', '3': 3, '4': 1, '5': 3, '10': 'callValue'},
    const {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'call_token_value', '3': 5, '4': 1, '5': 3, '10': 'callTokenValue'},
    const {'1': 'token_id', '3': 6, '4': 1, '5': 3, '10': 'tokenId'},
  ],
};

/// Descriptor for `TriggerSmartContract`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerSmartContractDescriptor = $convert.base64Decode('ChRUcmlnZ2VyU21hcnRDb250cmFjdBIjCg1vd25lcl9hZGRyZXNzGAEgASgMUgxvd25lckFkZHJlc3MSKQoQY29udHJhY3RfYWRkcmVzcxgCIAEoDFIPY29udHJhY3RBZGRyZXNzEh0KCmNhbGxfdmFsdWUYAyABKANSCWNhbGxWYWx1ZRISCgRkYXRhGAQgASgMUgRkYXRhEigKEGNhbGxfdG9rZW5fdmFsdWUYBSABKANSDmNhbGxUb2tlblZhbHVlEhkKCHRva2VuX2lkGAYgASgDUgd0b2tlbklk');
@$core.Deprecated('Use freezeBalanceContractDescriptor instead')
const FreezeBalanceContract$json = const {
  '1': 'FreezeBalanceContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'frozen_balance', '3': 2, '4': 1, '5': 3, '10': 'frozenBalance'},
    const {'1': 'frozen_duration', '3': 3, '4': 1, '5': 3, '10': 'frozenDuration'},
  ],
};

/// Descriptor for `FreezeBalanceContract`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List freezeBalanceContractDescriptor = $convert.base64Decode('ChVGcmVlemVCYWxhbmNlQ29udHJhY3QSIwoNb3duZXJfYWRkcmVzcxgBIAEoDFIMb3duZXJBZGRyZXNzEiUKDmZyb3plbl9iYWxhbmNlGAIgASgDUg1mcm96ZW5CYWxhbmNlEicKD2Zyb3plbl9kdXJhdGlvbhgDIAEoA1IOZnJvemVuRHVyYXRpb24=');
@$core.Deprecated('Use unfreezeBalanceContractDescriptor instead')
const UnfreezeBalanceContract$json = const {
  '1': 'UnfreezeBalanceContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
  ],
};

/// Descriptor for `UnfreezeBalanceContract`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unfreezeBalanceContractDescriptor = $convert.base64Decode('ChdVbmZyZWV6ZUJhbGFuY2VDb250cmFjdBIjCg1vd25lcl9hZGRyZXNzGAEgASgMUgxvd25lckFkZHJlc3M=');
@$core.Deprecated('Use unfreezeAssetContractDescriptor instead')
const UnfreezeAssetContract$json = const {
  '1': 'UnfreezeAssetContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
  ],
};

/// Descriptor for `UnfreezeAssetContract`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unfreezeAssetContractDescriptor = $convert.base64Decode('ChVVbmZyZWV6ZUFzc2V0Q29udHJhY3QSIwoNb3duZXJfYWRkcmVzcxgBIAEoDFIMb3duZXJBZGRyZXNz');
@$core.Deprecated('Use accountIdDescriptor instead')
const AccountId$json = const {
  '1': 'AccountId',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 12, '10': 'name'},
    const {'1': 'address', '3': 2, '4': 1, '5': 12, '10': 'address'},
  ],
};

/// Descriptor for `AccountId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountIdDescriptor = $convert.base64Decode('CglBY2NvdW50SWQSEgoEbmFtZRgBIAEoDFIEbmFtZRIYCgdhZGRyZXNzGAIgASgMUgdhZGRyZXNz');
@$core.Deprecated('Use acuthrityDescriptor instead')
const acuthrity$json = const {
  '1': 'acuthrity',
  '2': const [
    const {'1': 'account', '3': 1, '4': 1, '5': 11, '6': '.AccountId', '10': 'account'},
    const {'1': 'permission_name', '3': 2, '4': 1, '5': 12, '10': 'permissionName'},
  ],
};

/// Descriptor for `acuthrity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acuthrityDescriptor = $convert.base64Decode('CglhY3V0aHJpdHkSJAoHYWNjb3VudBgBIAEoCzIKLkFjY291bnRJZFIHYWNjb3VudBInCg9wZXJtaXNzaW9uX25hbWUYAiABKAxSDnBlcm1pc3Npb25OYW1l');
@$core.Deprecated('Use transactionDescriptor instead')
const Transaction$json = const {
  '1': 'Transaction',
  '2': const [
    const {'1': 'raw_data', '3': 1, '4': 1, '5': 11, '6': '.Transaction.raw', '10': 'rawData'},
    const {'1': 'signature', '3': 2, '4': 3, '5': 12, '10': 'signature'},
    const {'1': 'ret', '3': 5, '4': 3, '5': 11, '6': '.Transaction.Result', '10': 'ret'},
  ],
  '3': const [Transaction_Contract$json, Transaction_Result$json, Transaction_raw$json],
};

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction_Contract$json = const {
  '1': 'Contract',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.Transaction.Contract.ContractType', '10': 'type'},
    const {'1': 'parameter', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Any', '10': 'parameter'},
    const {'1': 'provider', '3': 3, '4': 1, '5': 12, '10': 'provider'},
    const {'1': 'ContractName', '3': 4, '4': 1, '5': 12, '10': 'ContractName'},
    const {'1': 'Permission_id', '3': 5, '4': 1, '5': 5, '10': 'PermissionId'},
  ],
  '4': const [Transaction_Contract_ContractType$json],
};

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction_Contract_ContractType$json = const {
  '1': 'ContractType',
  '2': const [
    const {'1': 'AccountCreateContract', '2': 0},
    const {'1': 'TransferContract', '2': 1},
    const {'1': 'TransferAssetContract', '2': 2},
    const {'1': 'VoteAssetContract', '2': 3},
    const {'1': 'VoteWitnessContract', '2': 4},
    const {'1': 'WitnessCreateContract', '2': 5},
    const {'1': 'AssetIssueContract', '2': 6},
    const {'1': 'WitnessUpdateContract', '2': 8},
    const {'1': 'ParticipateAssetIssueContract', '2': 9},
    const {'1': 'AccountUpdateContract', '2': 10},
    const {'1': 'FreezeBalanceContract', '2': 11},
    const {'1': 'UnfreezeBalanceContract', '2': 12},
    const {'1': 'WithdrawBalanceContract', '2': 13},
    const {'1': 'UnfreezeAssetContract', '2': 14},
    const {'1': 'UpdateAssetContract', '2': 15},
    const {'1': 'ProposalCreateContract', '2': 16},
    const {'1': 'ProposalApproveContract', '2': 17},
    const {'1': 'ProposalDeleteContract', '2': 18},
    const {'1': 'SetAccountIdContract', '2': 19},
    const {'1': 'CustomContract', '2': 20},
    const {'1': 'CreateSmartContract', '2': 30},
    const {'1': 'TriggerSmartContract', '2': 31},
    const {'1': 'GetContract', '2': 32},
    const {'1': 'UpdateSettingContract', '2': 33},
    const {'1': 'ExchangeCreateContract', '2': 41},
    const {'1': 'ExchangeInjectContract', '2': 42},
    const {'1': 'ExchangeWithdrawContract', '2': 43},
    const {'1': 'ExchangeTransactionContract', '2': 44},
    const {'1': 'UpdateEnergyLimitContract', '2': 45},
    const {'1': 'AccountPermissionUpdateContract', '2': 46},
    const {'1': 'ClearABIContract', '2': 48},
    const {'1': 'UpdateBrokerageContract', '2': 49},
    const {'1': 'ShieldedTransferContract', '2': 51},
    const {'1': 'MarketSellAssetContract', '2': 52},
    const {'1': 'MarketCancelOrderContract', '2': 53},
  ],
};

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction_Result$json = const {
  '1': 'Result',
  '2': const [
    const {'1': 'fee', '3': 1, '4': 1, '5': 3, '10': 'fee'},
    const {'1': 'ret', '3': 2, '4': 1, '5': 14, '6': '.Transaction.Result.code', '10': 'ret'},
  ],
  '4': const [Transaction_Result_code$json],
};

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction_Result_code$json = const {
  '1': 'code',
  '2': const [
    const {'1': 'SUCESS', '2': 0},
    const {'1': 'FAILED', '2': 1},
  ],
};

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction_raw$json = const {
  '1': 'raw',
  '2': const [
    const {'1': 'ref_block_bytes', '3': 1, '4': 1, '5': 12, '10': 'refBlockBytes'},
    const {'1': 'ref_block_num', '3': 3, '4': 1, '5': 3, '10': 'refBlockNum'},
    const {'1': 'ref_block_hash', '3': 4, '4': 1, '5': 12, '10': 'refBlockHash'},
    const {'1': 'expiration', '3': 8, '4': 1, '5': 3, '10': 'expiration'},
    const {'1': 'auths', '3': 9, '4': 3, '5': 11, '6': '.acuthrity', '10': 'auths'},
    const {'1': 'data', '3': 10, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'contract', '3': 11, '4': 3, '5': 11, '6': '.Transaction.Contract', '10': 'contract'},
    const {'1': 'scripts', '3': 12, '4': 1, '5': 12, '10': 'scripts'},
    const {'1': 'timestamp', '3': 14, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'fee_limit', '3': 18, '4': 1, '5': 3, '10': 'feeLimit'},
  ],
};

/// Descriptor for `Transaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionDescriptor = $convert.base64Decode('CgtUcmFuc2FjdGlvbhIrCghyYXdfZGF0YRgBIAEoCzIQLlRyYW5zYWN0aW9uLnJhd1IHcmF3RGF0YRIcCglzaWduYXR1cmUYAiADKAxSCXNpZ25hdHVyZRIlCgNyZXQYBSADKAsyEy5UcmFuc2FjdGlvbi5SZXN1bHRSA3JldBqnCQoIQ29udHJhY3QSNgoEdHlwZRgBIAEoDjIiLlRyYW5zYWN0aW9uLkNvbnRyYWN0LkNvbnRyYWN0VHlwZVIEdHlwZRIyCglwYXJhbWV0ZXIYAiABKAsyFC5nb29nbGUucHJvdG9idWYuQW55UglwYXJhbWV0ZXISGgoIcHJvdmlkZXIYAyABKAxSCHByb3ZpZGVyEiIKDENvbnRyYWN0TmFtZRgEIAEoDFIMQ29udHJhY3ROYW1lEiMKDVBlcm1pc3Npb25faWQYBSABKAVSDFBlcm1pc3Npb25JZCLJBwoMQ29udHJhY3RUeXBlEhkKFUFjY291bnRDcmVhdGVDb250cmFjdBAAEhQKEFRyYW5zZmVyQ29udHJhY3QQARIZChVUcmFuc2ZlckFzc2V0Q29udHJhY3QQAhIVChFWb3RlQXNzZXRDb250cmFjdBADEhcKE1ZvdGVXaXRuZXNzQ29udHJhY3QQBBIZChVXaXRuZXNzQ3JlYXRlQ29udHJhY3QQBRIWChJBc3NldElzc3VlQ29udHJhY3QQBhIZChVXaXRuZXNzVXBkYXRlQ29udHJhY3QQCBIhCh1QYXJ0aWNpcGF0ZUFzc2V0SXNzdWVDb250cmFjdBAJEhkKFUFjY291bnRVcGRhdGVDb250cmFjdBAKEhkKFUZyZWV6ZUJhbGFuY2VDb250cmFjdBALEhsKF1VuZnJlZXplQmFsYW5jZUNvbnRyYWN0EAwSGwoXV2l0aGRyYXdCYWxhbmNlQ29udHJhY3QQDRIZChVVbmZyZWV6ZUFzc2V0Q29udHJhY3QQDhIXChNVcGRhdGVBc3NldENvbnRyYWN0EA8SGgoWUHJvcG9zYWxDcmVhdGVDb250cmFjdBAQEhsKF1Byb3Bvc2FsQXBwcm92ZUNvbnRyYWN0EBESGgoWUHJvcG9zYWxEZWxldGVDb250cmFjdBASEhgKFFNldEFjY291bnRJZENvbnRyYWN0EBMSEgoOQ3VzdG9tQ29udHJhY3QQFBIXChNDcmVhdGVTbWFydENvbnRyYWN0EB4SGAoUVHJpZ2dlclNtYXJ0Q29udHJhY3QQHxIPCgtHZXRDb250cmFjdBAgEhkKFVVwZGF0ZVNldHRpbmdDb250cmFjdBAhEhoKFkV4Y2hhbmdlQ3JlYXRlQ29udHJhY3QQKRIaChZFeGNoYW5nZUluamVjdENvbnRyYWN0ECoSHAoYRXhjaGFuZ2VXaXRoZHJhd0NvbnRyYWN0ECsSHwobRXhjaGFuZ2VUcmFuc2FjdGlvbkNvbnRyYWN0ECwSHQoZVXBkYXRlRW5lcmd5TGltaXRDb250cmFjdBAtEiMKH0FjY291bnRQZXJtaXNzaW9uVXBkYXRlQ29udHJhY3QQLhIUChBDbGVhckFCSUNvbnRyYWN0EDASGwoXVXBkYXRlQnJva2VyYWdlQ29udHJhY3QQMRIcChhTaGllbGRlZFRyYW5zZmVyQ29udHJhY3QQMxIbChdNYXJrZXRTZWxsQXNzZXRDb250cmFjdBA0Eh0KGU1hcmtldENhbmNlbE9yZGVyQ29udHJhY3QQNRpmCgZSZXN1bHQSEAoDZmVlGAEgASgDUgNmZWUSKgoDcmV0GAIgASgOMhguVHJhbnNhY3Rpb24uUmVzdWx0LmNvZGVSA3JldCIeCgRjb2RlEgoKBlNVQ0VTUxAAEgoKBkZBSUxFRBABGtUCCgNyYXcSJgoPcmVmX2Jsb2NrX2J5dGVzGAEgASgMUg1yZWZCbG9ja0J5dGVzEiIKDXJlZl9ibG9ja19udW0YAyABKANSC3JlZkJsb2NrTnVtEiQKDnJlZl9ibG9ja19oYXNoGAQgASgMUgxyZWZCbG9ja0hhc2gSHgoKZXhwaXJhdGlvbhgIIAEoA1IKZXhwaXJhdGlvbhIgCgVhdXRocxgJIAMoCzIKLmFjdXRocml0eVIFYXV0aHMSEgoEZGF0YRgKIAEoDFIEZGF0YRIxCghjb250cmFjdBgLIAMoCzIVLlRyYW5zYWN0aW9uLkNvbnRyYWN0Ughjb250cmFjdBIYCgdzY3JpcHRzGAwgASgMUgdzY3JpcHRzEhwKCXRpbWVzdGFtcBgOIAEoA1IJdGltZXN0YW1wEhsKCWZlZV9saW1pdBgSIAEoA1IIZmVlTGltaXQ=');
@$core.Deprecated('Use transactionsDescriptor instead')
const Transactions$json = const {
  '1': 'Transactions',
  '2': const [
    const {'1': 'transactions', '3': 1, '4': 3, '5': 11, '6': '.Transaction', '10': 'transactions'},
  ],
};

/// Descriptor for `Transactions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionsDescriptor = $convert.base64Decode('CgxUcmFuc2FjdGlvbnMSMAoMdHJhbnNhY3Rpb25zGAEgAygLMgwuVHJhbnNhY3Rpb25SDHRyYW5zYWN0aW9ucw==');
@$core.Deprecated('Use blockHeaderDescriptor instead')
const BlockHeader$json = const {
  '1': 'BlockHeader',
  '2': const [
    const {'1': 'raw_data', '3': 1, '4': 1, '5': 11, '6': '.BlockHeader.raw', '10': 'rawData'},
    const {'1': 'witness_signature', '3': 2, '4': 1, '5': 12, '10': 'witnessSignature'},
  ],
  '3': const [BlockHeader_raw$json],
};

@$core.Deprecated('Use blockHeaderDescriptor instead')
const BlockHeader_raw$json = const {
  '1': 'raw',
  '2': const [
    const {'1': 'timestamp', '3': 1, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'txTrieRoot', '3': 2, '4': 1, '5': 12, '10': 'txTrieRoot'},
    const {'1': 'parentHash', '3': 3, '4': 1, '5': 12, '10': 'parentHash'},
    const {'1': 'number', '3': 7, '4': 1, '5': 3, '10': 'number'},
    const {'1': 'witness_id', '3': 8, '4': 1, '5': 3, '10': 'witnessId'},
    const {'1': 'witness_address', '3': 9, '4': 1, '5': 12, '10': 'witnessAddress'},
  ],
};

/// Descriptor for `BlockHeader`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockHeaderDescriptor = $convert.base64Decode('CgtCbG9ja0hlYWRlchIrCghyYXdfZGF0YRgBIAEoCzIQLkJsb2NrSGVhZGVyLnJhd1IHcmF3RGF0YRIrChF3aXRuZXNzX3NpZ25hdHVyZRgCIAEoDFIQd2l0bmVzc1NpZ25hdHVyZRrDAQoDcmF3EhwKCXRpbWVzdGFtcBgBIAEoA1IJdGltZXN0YW1wEh4KCnR4VHJpZVJvb3QYAiABKAxSCnR4VHJpZVJvb3QSHgoKcGFyZW50SGFzaBgDIAEoDFIKcGFyZW50SGFzaBIWCgZudW1iZXIYByABKANSBm51bWJlchIdCgp3aXRuZXNzX2lkGAggASgDUgl3aXRuZXNzSWQSJwoPd2l0bmVzc19hZGRyZXNzGAkgASgMUg53aXRuZXNzQWRkcmVzcw==');
