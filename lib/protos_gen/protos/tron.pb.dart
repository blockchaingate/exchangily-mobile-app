///
//  Generated code. Do not modify.
//  source: protos/tron.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../any.pb.dart' as $0;

import 'tron.pbenum.dart';

export 'tron.pbenum.dart';

class TransferContract extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TransferContract', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownerAddress', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'toAddress', $pb.PbFieldType.OY)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..hasRequiredFields = false
  ;

  TransferContract._() : super();
  factory TransferContract({
    $core.List<$core.int>? ownerAddress,
    $core.List<$core.int>? toAddress,
    $fixnum.Int64? amount,
  }) {
    final _result = create();
    if (ownerAddress != null) {
      _result.ownerAddress = ownerAddress;
    }
    if (toAddress != null) {
      _result.toAddress = toAddress;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory TransferContract.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransferContract.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransferContract clone() => TransferContract()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransferContract copyWith(void Function(TransferContract) updates) => super.copyWith((message) => updates(message as TransferContract)) as TransferContract; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TransferContract create() => TransferContract._();
  TransferContract createEmptyInstance() => create();
  static $pb.PbList<TransferContract> createRepeated() => $pb.PbList<TransferContract>();
  @$core.pragma('dart2js:noInline')
  static TransferContract getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransferContract>(create);
  static TransferContract? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ownerAddress => $_getN(0);
  @$pb.TagNumber(1)
  set ownerAddress($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOwnerAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get toAddress => $_getN(1);
  @$pb.TagNumber(2)
  set toAddress($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearToAddress() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
}

class TransferAssetContract extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TransferAssetContract', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetName', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownerAddress', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'toAddress', $pb.PbFieldType.OY)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..hasRequiredFields = false
  ;

  TransferAssetContract._() : super();
  factory TransferAssetContract({
    $core.List<$core.int>? assetName,
    $core.List<$core.int>? ownerAddress,
    $core.List<$core.int>? toAddress,
    $fixnum.Int64? amount,
  }) {
    final _result = create();
    if (assetName != null) {
      _result.assetName = assetName;
    }
    if (ownerAddress != null) {
      _result.ownerAddress = ownerAddress;
    }
    if (toAddress != null) {
      _result.toAddress = toAddress;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory TransferAssetContract.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransferAssetContract.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransferAssetContract clone() => TransferAssetContract()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransferAssetContract copyWith(void Function(TransferAssetContract) updates) => super.copyWith((message) => updates(message as TransferAssetContract)) as TransferAssetContract; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TransferAssetContract create() => TransferAssetContract._();
  TransferAssetContract createEmptyInstance() => create();
  static $pb.PbList<TransferAssetContract> createRepeated() => $pb.PbList<TransferAssetContract>();
  @$core.pragma('dart2js:noInline')
  static TransferAssetContract getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransferAssetContract>(create);
  static TransferAssetContract? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get assetName => $_getN(0);
  @$pb.TagNumber(1)
  set assetName($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetName() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get ownerAddress => $_getN(1);
  @$pb.TagNumber(2)
  set ownerAddress($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOwnerAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerAddress() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get toAddress => $_getN(2);
  @$pb.TagNumber(3)
  set toAddress($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearToAddress() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get amount => $_getI64(3);
  @$pb.TagNumber(4)
  set amount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => clearField(4);
}

class TriggerSmartContract extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TriggerSmartContract', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownerAddress', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contractAddress', $pb.PbFieldType.OY)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callValue')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callTokenValue')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenId')
    ..hasRequiredFields = false
  ;

  TriggerSmartContract._() : super();
  factory TriggerSmartContract({
    $core.List<$core.int>? ownerAddress,
    $core.List<$core.int>? contractAddress,
    $fixnum.Int64? callValue,
    $core.List<$core.int>? data,
    $fixnum.Int64? callTokenValue,
    $fixnum.Int64? tokenId,
  }) {
    final _result = create();
    if (ownerAddress != null) {
      _result.ownerAddress = ownerAddress;
    }
    if (contractAddress != null) {
      _result.contractAddress = contractAddress;
    }
    if (callValue != null) {
      _result.callValue = callValue;
    }
    if (data != null) {
      _result.data = data;
    }
    if (callTokenValue != null) {
      _result.callTokenValue = callTokenValue;
    }
    if (tokenId != null) {
      _result.tokenId = tokenId;
    }
    return _result;
  }
  factory TriggerSmartContract.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TriggerSmartContract.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TriggerSmartContract clone() => TriggerSmartContract()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TriggerSmartContract copyWith(void Function(TriggerSmartContract) updates) => super.copyWith((message) => updates(message as TriggerSmartContract)) as TriggerSmartContract; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TriggerSmartContract create() => TriggerSmartContract._();
  TriggerSmartContract createEmptyInstance() => create();
  static $pb.PbList<TriggerSmartContract> createRepeated() => $pb.PbList<TriggerSmartContract>();
  @$core.pragma('dart2js:noInline')
  static TriggerSmartContract getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TriggerSmartContract>(create);
  static TriggerSmartContract? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ownerAddress => $_getN(0);
  @$pb.TagNumber(1)
  set ownerAddress($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOwnerAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get contractAddress => $_getN(1);
  @$pb.TagNumber(2)
  set contractAddress($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContractAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearContractAddress() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get callValue => $_getI64(2);
  @$pb.TagNumber(3)
  set callValue($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(3);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get callTokenValue => $_getI64(4);
  @$pb.TagNumber(5)
  set callTokenValue($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCallTokenValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearCallTokenValue() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get tokenId => $_getI64(5);
  @$pb.TagNumber(6)
  set tokenId($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTokenId() => $_has(5);
  @$pb.TagNumber(6)
  void clearTokenId() => clearField(6);
}

class FreezeBalanceContract extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FreezeBalanceContract', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownerAddress', $pb.PbFieldType.OY)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frozenBalance')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frozenDuration')
    ..hasRequiredFields = false
  ;

  FreezeBalanceContract._() : super();
  factory FreezeBalanceContract({
    $core.List<$core.int>? ownerAddress,
    $fixnum.Int64? frozenBalance,
    $fixnum.Int64? frozenDuration,
  }) {
    final _result = create();
    if (ownerAddress != null) {
      _result.ownerAddress = ownerAddress;
    }
    if (frozenBalance != null) {
      _result.frozenBalance = frozenBalance;
    }
    if (frozenDuration != null) {
      _result.frozenDuration = frozenDuration;
    }
    return _result;
  }
  factory FreezeBalanceContract.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FreezeBalanceContract.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FreezeBalanceContract clone() => FreezeBalanceContract()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FreezeBalanceContract copyWith(void Function(FreezeBalanceContract) updates) => super.copyWith((message) => updates(message as FreezeBalanceContract)) as FreezeBalanceContract; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FreezeBalanceContract create() => FreezeBalanceContract._();
  FreezeBalanceContract createEmptyInstance() => create();
  static $pb.PbList<FreezeBalanceContract> createRepeated() => $pb.PbList<FreezeBalanceContract>();
  @$core.pragma('dart2js:noInline')
  static FreezeBalanceContract getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FreezeBalanceContract>(create);
  static FreezeBalanceContract? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ownerAddress => $_getN(0);
  @$pb.TagNumber(1)
  set ownerAddress($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOwnerAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerAddress() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get frozenBalance => $_getI64(1);
  @$pb.TagNumber(2)
  set frozenBalance($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFrozenBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrozenBalance() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get frozenDuration => $_getI64(2);
  @$pb.TagNumber(3)
  set frozenDuration($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFrozenDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrozenDuration() => clearField(3);
}

class UnfreezeBalanceContract extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UnfreezeBalanceContract', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownerAddress', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UnfreezeBalanceContract._() : super();
  factory UnfreezeBalanceContract({
    $core.List<$core.int>? ownerAddress,
  }) {
    final _result = create();
    if (ownerAddress != null) {
      _result.ownerAddress = ownerAddress;
    }
    return _result;
  }
  factory UnfreezeBalanceContract.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnfreezeBalanceContract.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnfreezeBalanceContract clone() => UnfreezeBalanceContract()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnfreezeBalanceContract copyWith(void Function(UnfreezeBalanceContract) updates) => super.copyWith((message) => updates(message as UnfreezeBalanceContract)) as UnfreezeBalanceContract; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UnfreezeBalanceContract create() => UnfreezeBalanceContract._();
  UnfreezeBalanceContract createEmptyInstance() => create();
  static $pb.PbList<UnfreezeBalanceContract> createRepeated() => $pb.PbList<UnfreezeBalanceContract>();
  @$core.pragma('dart2js:noInline')
  static UnfreezeBalanceContract getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnfreezeBalanceContract>(create);
  static UnfreezeBalanceContract? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ownerAddress => $_getN(0);
  @$pb.TagNumber(1)
  set ownerAddress($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOwnerAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerAddress() => clearField(1);
}

class UnfreezeAssetContract extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UnfreezeAssetContract', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownerAddress', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  UnfreezeAssetContract._() : super();
  factory UnfreezeAssetContract({
    $core.List<$core.int>? ownerAddress,
  }) {
    final _result = create();
    if (ownerAddress != null) {
      _result.ownerAddress = ownerAddress;
    }
    return _result;
  }
  factory UnfreezeAssetContract.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnfreezeAssetContract.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnfreezeAssetContract clone() => UnfreezeAssetContract()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnfreezeAssetContract copyWith(void Function(UnfreezeAssetContract) updates) => super.copyWith((message) => updates(message as UnfreezeAssetContract)) as UnfreezeAssetContract; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UnfreezeAssetContract create() => UnfreezeAssetContract._();
  UnfreezeAssetContract createEmptyInstance() => create();
  static $pb.PbList<UnfreezeAssetContract> createRepeated() => $pb.PbList<UnfreezeAssetContract>();
  @$core.pragma('dart2js:noInline')
  static UnfreezeAssetContract getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnfreezeAssetContract>(create);
  static UnfreezeAssetContract? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ownerAddress => $_getN(0);
  @$pb.TagNumber(1)
  set ownerAddress($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOwnerAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerAddress() => clearField(1);
}

class AccountId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AccountId', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  AccountId._() : super();
  factory AccountId({
    $core.List<$core.int>? name,
    $core.List<$core.int>? address,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (address != null) {
      _result.address = address;
    }
    return _result;
  }
  factory AccountId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountId clone() => AccountId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountId copyWith(void Function(AccountId) updates) => super.copyWith((message) => updates(message as AccountId)) as AccountId; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AccountId create() => AccountId._();
  AccountId createEmptyInstance() => create();
  static $pb.PbList<AccountId> createRepeated() => $pb.PbList<AccountId>();
  @$core.pragma('dart2js:noInline')
  static AccountId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountId>(create);
  static AccountId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get name => $_getN(0);
  @$pb.TagNumber(1)
  set name($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get address => $_getN(1);
  @$pb.TagNumber(2)
  set address($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => clearField(2);
}

class acuthrity extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'acuthrity', createEmptyInstance: create)
    ..aOM<AccountId>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: AccountId.create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionName', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  acuthrity._() : super();
  factory acuthrity({
    AccountId? account,
    $core.List<$core.int>? permissionName,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    if (permissionName != null) {
      _result.permissionName = permissionName;
    }
    return _result;
  }
  factory acuthrity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory acuthrity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  acuthrity clone() => acuthrity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  acuthrity copyWith(void Function(acuthrity) updates) => super.copyWith((message) => updates(message as acuthrity)) as acuthrity; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static acuthrity create() => acuthrity._();
  acuthrity createEmptyInstance() => create();
  static $pb.PbList<acuthrity> createRepeated() => $pb.PbList<acuthrity>();
  @$core.pragma('dart2js:noInline')
  static acuthrity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<acuthrity>(create);
  static acuthrity? _defaultInstance;

  @$pb.TagNumber(1)
  AccountId get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(AccountId v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  AccountId ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get permissionName => $_getN(1);
  @$pb.TagNumber(2)
  set permissionName($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPermissionName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissionName() => clearField(2);
}

class Transaction_Contract extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Transaction.Contract', createEmptyInstance: create)
    ..e<Transaction_Contract_ContractType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: Transaction_Contract_ContractType.AccountCreateContract, valueOf: Transaction_Contract_ContractType.valueOf, enumValues: Transaction_Contract_ContractType.values)
    ..aOM<$0.Any>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parameter', subBuilder: $0.Any.create)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'provider', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ContractName', $pb.PbFieldType.OY, protoName: 'ContractName')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PermissionId', $pb.PbFieldType.O3, protoName: 'Permission_id')
    ..hasRequiredFields = false
  ;

  Transaction_Contract._() : super();
  factory Transaction_Contract({
    Transaction_Contract_ContractType? type,
    $0.Any? parameter,
    $core.List<$core.int>? provider,
    $core.List<$core.int>? contractName,
    $core.int? permissionId,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (parameter != null) {
      _result.parameter = parameter;
    }
    if (provider != null) {
      _result.provider = provider;
    }
    if (contractName != null) {
      _result.contractName = contractName;
    }
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    return _result;
  }
  factory Transaction_Contract.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Transaction_Contract.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Transaction_Contract clone() => Transaction_Contract()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Transaction_Contract copyWith(void Function(Transaction_Contract) updates) => super.copyWith((message) => updates(message as Transaction_Contract)) as Transaction_Contract; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Transaction_Contract create() => Transaction_Contract._();
  Transaction_Contract createEmptyInstance() => create();
  static $pb.PbList<Transaction_Contract> createRepeated() => $pb.PbList<Transaction_Contract>();
  @$core.pragma('dart2js:noInline')
  static Transaction_Contract getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Transaction_Contract>(create);
  static Transaction_Contract? _defaultInstance;

  @$pb.TagNumber(1)
  Transaction_Contract_ContractType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Transaction_Contract_ContractType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $0.Any get parameter => $_getN(1);
  @$pb.TagNumber(2)
  set parameter($0.Any v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParameter() => $_has(1);
  @$pb.TagNumber(2)
  void clearParameter() => clearField(2);
  @$pb.TagNumber(2)
  $0.Any ensureParameter() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get provider => $_getN(2);
  @$pb.TagNumber(3)
  set provider($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProvider() => $_has(2);
  @$pb.TagNumber(3)
  void clearProvider() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get contractName => $_getN(3);
  @$pb.TagNumber(4)
  set contractName($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasContractName() => $_has(3);
  @$pb.TagNumber(4)
  void clearContractName() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get permissionId => $_getIZ(4);
  @$pb.TagNumber(5)
  set permissionId($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPermissionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPermissionId() => clearField(5);
}

class Transaction_Result extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Transaction.Result', createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fee')
    ..e<Transaction_Result_code>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ret', $pb.PbFieldType.OE, defaultOrMaker: Transaction_Result_code.SUCESS, valueOf: Transaction_Result_code.valueOf, enumValues: Transaction_Result_code.values)
    ..hasRequiredFields = false
  ;

  Transaction_Result._() : super();
  factory Transaction_Result({
    $fixnum.Int64? fee,
    Transaction_Result_code? ret,
  }) {
    final _result = create();
    if (fee != null) {
      _result.fee = fee;
    }
    if (ret != null) {
      _result.ret = ret;
    }
    return _result;
  }
  factory Transaction_Result.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Transaction_Result.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Transaction_Result clone() => Transaction_Result()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Transaction_Result copyWith(void Function(Transaction_Result) updates) => super.copyWith((message) => updates(message as Transaction_Result)) as Transaction_Result; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Transaction_Result create() => Transaction_Result._();
  Transaction_Result createEmptyInstance() => create();
  static $pb.PbList<Transaction_Result> createRepeated() => $pb.PbList<Transaction_Result>();
  @$core.pragma('dart2js:noInline')
  static Transaction_Result getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Transaction_Result>(create);
  static Transaction_Result? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fee => $_getI64(0);
  @$pb.TagNumber(1)
  set fee($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFee() => $_has(0);
  @$pb.TagNumber(1)
  void clearFee() => clearField(1);

  @$pb.TagNumber(2)
  Transaction_Result_code get ret => $_getN(1);
  @$pb.TagNumber(2)
  set ret(Transaction_Result_code v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRet() => $_has(1);
  @$pb.TagNumber(2)
  void clearRet() => clearField(2);
}

class Transaction_raw extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Transaction.raw', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refBlockBytes', $pb.PbFieldType.OY)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refBlockNum')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refBlockHash', $pb.PbFieldType.OY)
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiration')
    ..pc<acuthrity>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'auths', $pb.PbFieldType.PM, subBuilder: acuthrity.create)
    ..a<$core.List<$core.int>>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..pc<Transaction_Contract>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contract', $pb.PbFieldType.PM, subBuilder: Transaction_Contract.create)
    ..a<$core.List<$core.int>>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scripts', $pb.PbFieldType.OY)
    ..aInt64(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..aInt64(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feeLimit')
    ..hasRequiredFields = false
  ;

  Transaction_raw._() : super();
  factory Transaction_raw({
    $core.List<$core.int>? refBlockBytes,
    $fixnum.Int64? refBlockNum,
    $core.List<$core.int>? refBlockHash,
    $fixnum.Int64? expiration,
    $core.Iterable<acuthrity>? auths,
    $core.List<$core.int>? data,
    $core.Iterable<Transaction_Contract>? contract,
    $core.List<$core.int>? scripts,
    $fixnum.Int64? timestamp,
    $fixnum.Int64? feeLimit,
  }) {
    final _result = create();
    if (refBlockBytes != null) {
      _result.refBlockBytes = refBlockBytes;
    }
    if (refBlockNum != null) {
      _result.refBlockNum = refBlockNum;
    }
    if (refBlockHash != null) {
      _result.refBlockHash = refBlockHash;
    }
    if (expiration != null) {
      _result.expiration = expiration;
    }
    if (auths != null) {
      _result.auths.addAll(auths);
    }
    if (data != null) {
      _result.data = data;
    }
    if (contract != null) {
      _result.contract.addAll(contract);
    }
    if (scripts != null) {
      _result.scripts = scripts;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (feeLimit != null) {
      _result.feeLimit = feeLimit;
    }
    return _result;
  }
  factory Transaction_raw.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Transaction_raw.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Transaction_raw clone() => Transaction_raw()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Transaction_raw copyWith(void Function(Transaction_raw) updates) => super.copyWith((message) => updates(message as Transaction_raw)) as Transaction_raw; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Transaction_raw create() => Transaction_raw._();
  Transaction_raw createEmptyInstance() => create();
  static $pb.PbList<Transaction_raw> createRepeated() => $pb.PbList<Transaction_raw>();
  @$core.pragma('dart2js:noInline')
  static Transaction_raw getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Transaction_raw>(create);
  static Transaction_raw? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get refBlockBytes => $_getN(0);
  @$pb.TagNumber(1)
  set refBlockBytes($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRefBlockBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefBlockBytes() => clearField(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get refBlockNum => $_getI64(1);
  @$pb.TagNumber(3)
  set refBlockNum($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasRefBlockNum() => $_has(1);
  @$pb.TagNumber(3)
  void clearRefBlockNum() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get refBlockHash => $_getN(2);
  @$pb.TagNumber(4)
  set refBlockHash($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasRefBlockHash() => $_has(2);
  @$pb.TagNumber(4)
  void clearRefBlockHash() => clearField(4);

  @$pb.TagNumber(8)
  $fixnum.Int64 get expiration => $_getI64(3);
  @$pb.TagNumber(8)
  set expiration($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(8)
  $core.bool hasExpiration() => $_has(3);
  @$pb.TagNumber(8)
  void clearExpiration() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<acuthrity> get auths => $_getList(4);

  @$pb.TagNumber(10)
  $core.List<$core.int> get data => $_getN(5);
  @$pb.TagNumber(10)
  set data($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(10)
  $core.bool hasData() => $_has(5);
  @$pb.TagNumber(10)
  void clearData() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<Transaction_Contract> get contract => $_getList(6);

  @$pb.TagNumber(12)
  $core.List<$core.int> get scripts => $_getN(7);
  @$pb.TagNumber(12)
  set scripts($core.List<$core.int> v) { $_setBytes(7, v); }
  @$pb.TagNumber(12)
  $core.bool hasScripts() => $_has(7);
  @$pb.TagNumber(12)
  void clearScripts() => clearField(12);

  @$pb.TagNumber(14)
  $fixnum.Int64 get timestamp => $_getI64(8);
  @$pb.TagNumber(14)
  set timestamp($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(14)
  $core.bool hasTimestamp() => $_has(8);
  @$pb.TagNumber(14)
  void clearTimestamp() => clearField(14);

  @$pb.TagNumber(18)
  $fixnum.Int64 get feeLimit => $_getI64(9);
  @$pb.TagNumber(18)
  set feeLimit($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(18)
  $core.bool hasFeeLimit() => $_has(9);
  @$pb.TagNumber(18)
  void clearFeeLimit() => clearField(18);
}

class Transaction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Transaction', createEmptyInstance: create)
    ..aOM<Transaction_raw>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawData', subBuilder: Transaction_raw.create)
    ..p<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature', $pb.PbFieldType.PY)
    ..pc<Transaction_Result>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ret', $pb.PbFieldType.PM, subBuilder: Transaction_Result.create)
    ..hasRequiredFields = false
  ;

  Transaction._() : super();
  factory Transaction({
    Transaction_raw? rawData,
    $core.Iterable<$core.List<$core.int>>? signature,
    $core.Iterable<Transaction_Result>? ret,
  }) {
    final _result = create();
    if (rawData != null) {
      _result.rawData = rawData;
    }
    if (signature != null) {
      _result.signature.addAll(signature);
    }
    if (ret != null) {
      _result.ret.addAll(ret);
    }
    return _result;
  }
  factory Transaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Transaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Transaction clone() => Transaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Transaction copyWith(void Function(Transaction) updates) => super.copyWith((message) => updates(message as Transaction)) as Transaction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Transaction create() => Transaction._();
  Transaction createEmptyInstance() => create();
  static $pb.PbList<Transaction> createRepeated() => $pb.PbList<Transaction>();
  @$core.pragma('dart2js:noInline')
  static Transaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Transaction>(create);
  static Transaction? _defaultInstance;

  @$pb.TagNumber(1)
  Transaction_raw get rawData => $_getN(0);
  @$pb.TagNumber(1)
  set rawData(Transaction_raw v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRawData() => $_has(0);
  @$pb.TagNumber(1)
  void clearRawData() => clearField(1);
  @$pb.TagNumber(1)
  Transaction_raw ensureRawData() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.List<$core.int>> get signature => $_getList(1);

  @$pb.TagNumber(5)
  $core.List<Transaction_Result> get ret => $_getList(2);
}

class Transactions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Transactions', createEmptyInstance: create)
    ..pc<Transaction>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transactions', $pb.PbFieldType.PM, subBuilder: Transaction.create)
    ..hasRequiredFields = false
  ;

  Transactions._() : super();
  factory Transactions({
    $core.Iterable<Transaction>? transactions,
  }) {
    final _result = create();
    if (transactions != null) {
      _result.transactions.addAll(transactions);
    }
    return _result;
  }
  factory Transactions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Transactions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Transactions clone() => Transactions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Transactions copyWith(void Function(Transactions) updates) => super.copyWith((message) => updates(message as Transactions)) as Transactions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Transactions create() => Transactions._();
  Transactions createEmptyInstance() => create();
  static $pb.PbList<Transactions> createRepeated() => $pb.PbList<Transactions>();
  @$core.pragma('dart2js:noInline')
  static Transactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Transactions>(create);
  static Transactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Transaction> get transactions => $_getList(0);
}

class BlockHeader_raw extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BlockHeader.raw', createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txTrieRoot', $pb.PbFieldType.OY, protoName: 'txTrieRoot')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parentHash', $pb.PbFieldType.OY, protoName: 'parentHash')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'number')
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'witnessId')
    ..a<$core.List<$core.int>>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'witnessAddress', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  BlockHeader_raw._() : super();
  factory BlockHeader_raw({
    $fixnum.Int64? timestamp,
    $core.List<$core.int>? txTrieRoot,
    $core.List<$core.int>? parentHash,
    $fixnum.Int64? number,
    $fixnum.Int64? witnessId,
    $core.List<$core.int>? witnessAddress,
  }) {
    final _result = create();
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (txTrieRoot != null) {
      _result.txTrieRoot = txTrieRoot;
    }
    if (parentHash != null) {
      _result.parentHash = parentHash;
    }
    if (number != null) {
      _result.number = number;
    }
    if (witnessId != null) {
      _result.witnessId = witnessId;
    }
    if (witnessAddress != null) {
      _result.witnessAddress = witnessAddress;
    }
    return _result;
  }
  factory BlockHeader_raw.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockHeader_raw.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockHeader_raw clone() => BlockHeader_raw()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockHeader_raw copyWith(void Function(BlockHeader_raw) updates) => super.copyWith((message) => updates(message as BlockHeader_raw)) as BlockHeader_raw; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BlockHeader_raw create() => BlockHeader_raw._();
  BlockHeader_raw createEmptyInstance() => create();
  static $pb.PbList<BlockHeader_raw> createRepeated() => $pb.PbList<BlockHeader_raw>();
  @$core.pragma('dart2js:noInline')
  static BlockHeader_raw getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockHeader_raw>(create);
  static BlockHeader_raw? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get txTrieRoot => $_getN(1);
  @$pb.TagNumber(2)
  set txTrieRoot($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTxTrieRoot() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxTrieRoot() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get parentHash => $_getN(2);
  @$pb.TagNumber(3)
  set parentHash($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasParentHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentHash() => clearField(3);

  @$pb.TagNumber(7)
  $fixnum.Int64 get number => $_getI64(3);
  @$pb.TagNumber(7)
  set number($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(7)
  $core.bool hasNumber() => $_has(3);
  @$pb.TagNumber(7)
  void clearNumber() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get witnessId => $_getI64(4);
  @$pb.TagNumber(8)
  set witnessId($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(8)
  $core.bool hasWitnessId() => $_has(4);
  @$pb.TagNumber(8)
  void clearWitnessId() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get witnessAddress => $_getN(5);
  @$pb.TagNumber(9)
  set witnessAddress($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(9)
  $core.bool hasWitnessAddress() => $_has(5);
  @$pb.TagNumber(9)
  void clearWitnessAddress() => clearField(9);
}

class BlockHeader extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BlockHeader', createEmptyInstance: create)
    ..aOM<BlockHeader_raw>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawData', subBuilder: BlockHeader_raw.create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'witnessSignature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  BlockHeader._() : super();
  factory BlockHeader({
    BlockHeader_raw? rawData,
    $core.List<$core.int>? witnessSignature,
  }) {
    final _result = create();
    if (rawData != null) {
      _result.rawData = rawData;
    }
    if (witnessSignature != null) {
      _result.witnessSignature = witnessSignature;
    }
    return _result;
  }
  factory BlockHeader.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockHeader.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockHeader clone() => BlockHeader()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockHeader copyWith(void Function(BlockHeader) updates) => super.copyWith((message) => updates(message as BlockHeader)) as BlockHeader; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BlockHeader create() => BlockHeader._();
  BlockHeader createEmptyInstance() => create();
  static $pb.PbList<BlockHeader> createRepeated() => $pb.PbList<BlockHeader>();
  @$core.pragma('dart2js:noInline')
  static BlockHeader getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockHeader>(create);
  static BlockHeader? _defaultInstance;

  @$pb.TagNumber(1)
  BlockHeader_raw get rawData => $_getN(0);
  @$pb.TagNumber(1)
  set rawData(BlockHeader_raw v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRawData() => $_has(0);
  @$pb.TagNumber(1)
  void clearRawData() => clearField(1);
  @$pb.TagNumber(1)
  BlockHeader_raw ensureRawData() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get witnessSignature => $_getN(1);
  @$pb.TagNumber(2)
  set witnessSignature($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWitnessSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearWitnessSignature() => clearField(2);
}

