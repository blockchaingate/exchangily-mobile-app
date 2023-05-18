///
//  Generated code. Do not modify.
//  source: protos/tron.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Transaction_Contract_ContractType extends $pb.ProtobufEnum {
  static const Transaction_Contract_ContractType AccountCreateContract = Transaction_Contract_ContractType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AccountCreateContract');
  static const Transaction_Contract_ContractType TransferContract = Transaction_Contract_ContractType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TransferContract');
  static const Transaction_Contract_ContractType TransferAssetContract = Transaction_Contract_ContractType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TransferAssetContract');
  static const Transaction_Contract_ContractType VoteAssetContract = Transaction_Contract_ContractType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VoteAssetContract');
  static const Transaction_Contract_ContractType VoteWitnessContract = Transaction_Contract_ContractType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VoteWitnessContract');
  static const Transaction_Contract_ContractType WitnessCreateContract = Transaction_Contract_ContractType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WitnessCreateContract');
  static const Transaction_Contract_ContractType AssetIssueContract = Transaction_Contract_ContractType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AssetIssueContract');
  static const Transaction_Contract_ContractType WitnessUpdateContract = Transaction_Contract_ContractType._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WitnessUpdateContract');
  static const Transaction_Contract_ContractType ParticipateAssetIssueContract = Transaction_Contract_ContractType._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ParticipateAssetIssueContract');
  static const Transaction_Contract_ContractType AccountUpdateContract = Transaction_Contract_ContractType._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AccountUpdateContract');
  static const Transaction_Contract_ContractType FreezeBalanceContract = Transaction_Contract_ContractType._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FreezeBalanceContract');
  static const Transaction_Contract_ContractType UnfreezeBalanceContract = Transaction_Contract_ContractType._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UnfreezeBalanceContract');
  static const Transaction_Contract_ContractType WithdrawBalanceContract = Transaction_Contract_ContractType._(13, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WithdrawBalanceContract');
  static const Transaction_Contract_ContractType UnfreezeAssetContract = Transaction_Contract_ContractType._(14, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UnfreezeAssetContract');
  static const Transaction_Contract_ContractType UpdateAssetContract = Transaction_Contract_ContractType._(15, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UpdateAssetContract');
  static const Transaction_Contract_ContractType ProposalCreateContract = Transaction_Contract_ContractType._(16, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ProposalCreateContract');
  static const Transaction_Contract_ContractType ProposalApproveContract = Transaction_Contract_ContractType._(17, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ProposalApproveContract');
  static const Transaction_Contract_ContractType ProposalDeleteContract = Transaction_Contract_ContractType._(18, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ProposalDeleteContract');
  static const Transaction_Contract_ContractType SetAccountIdContract = Transaction_Contract_ContractType._(19, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SetAccountIdContract');
  static const Transaction_Contract_ContractType CustomContract = Transaction_Contract_ContractType._(20, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CustomContract');
  static const Transaction_Contract_ContractType CreateSmartContract = Transaction_Contract_ContractType._(30, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CreateSmartContract');
  static const Transaction_Contract_ContractType TriggerSmartContract = Transaction_Contract_ContractType._(31, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TriggerSmartContract');
  static const Transaction_Contract_ContractType GetContract = Transaction_Contract_ContractType._(32, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GetContract');
  static const Transaction_Contract_ContractType UpdateSettingContract = Transaction_Contract_ContractType._(33, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UpdateSettingContract');
  static const Transaction_Contract_ContractType ExchangeCreateContract = Transaction_Contract_ContractType._(41, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ExchangeCreateContract');
  static const Transaction_Contract_ContractType ExchangeInjectContract = Transaction_Contract_ContractType._(42, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ExchangeInjectContract');
  static const Transaction_Contract_ContractType ExchangeWithdrawContract = Transaction_Contract_ContractType._(43, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ExchangeWithdrawContract');
  static const Transaction_Contract_ContractType ExchangeTransactionContract = Transaction_Contract_ContractType._(44, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ExchangeTransactionContract');
  static const Transaction_Contract_ContractType UpdateEnergyLimitContract = Transaction_Contract_ContractType._(45, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UpdateEnergyLimitContract');
  static const Transaction_Contract_ContractType AccountPermissionUpdateContract = Transaction_Contract_ContractType._(46, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AccountPermissionUpdateContract');
  static const Transaction_Contract_ContractType ClearABIContract = Transaction_Contract_ContractType._(48, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ClearABIContract');
  static const Transaction_Contract_ContractType UpdateBrokerageContract = Transaction_Contract_ContractType._(49, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UpdateBrokerageContract');
  static const Transaction_Contract_ContractType ShieldedTransferContract = Transaction_Contract_ContractType._(51, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ShieldedTransferContract');
  static const Transaction_Contract_ContractType MarketSellAssetContract = Transaction_Contract_ContractType._(52, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MarketSellAssetContract');
  static const Transaction_Contract_ContractType MarketCancelOrderContract = Transaction_Contract_ContractType._(53, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MarketCancelOrderContract');

  static const $core.List<Transaction_Contract_ContractType> values = <Transaction_Contract_ContractType> [
    AccountCreateContract,
    TransferContract,
    TransferAssetContract,
    VoteAssetContract,
    VoteWitnessContract,
    WitnessCreateContract,
    AssetIssueContract,
    WitnessUpdateContract,
    ParticipateAssetIssueContract,
    AccountUpdateContract,
    FreezeBalanceContract,
    UnfreezeBalanceContract,
    WithdrawBalanceContract,
    UnfreezeAssetContract,
    UpdateAssetContract,
    ProposalCreateContract,
    ProposalApproveContract,
    ProposalDeleteContract,
    SetAccountIdContract,
    CustomContract,
    CreateSmartContract,
    TriggerSmartContract,
    GetContract,
    UpdateSettingContract,
    ExchangeCreateContract,
    ExchangeInjectContract,
    ExchangeWithdrawContract,
    ExchangeTransactionContract,
    UpdateEnergyLimitContract,
    AccountPermissionUpdateContract,
    ClearABIContract,
    UpdateBrokerageContract,
    ShieldedTransferContract,
    MarketSellAssetContract,
    MarketCancelOrderContract,
  ];

  static final $core.Map<$core.int, Transaction_Contract_ContractType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Transaction_Contract_ContractType? valueOf($core.int value) => _byValue[value];

  const Transaction_Contract_ContractType._($core.int v, $core.String n) : super(v, n);
}

class Transaction_Result_code extends $pb.ProtobufEnum {
  static const Transaction_Result_code SUCESS = Transaction_Result_code._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUCESS');
  static const Transaction_Result_code FAILED = Transaction_Result_code._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FAILED');

  static const $core.List<Transaction_Result_code> values = <Transaction_Result_code> [
    SUCESS,
    FAILED,
  ];

  static final $core.Map<$core.int, Transaction_Result_code> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Transaction_Result_code? valueOf($core.int value) => _byValue[value];

  const Transaction_Result_code._($core.int v, $core.String n) : super(v, n);
}

