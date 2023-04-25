import 'dart:math';

import 'package:isar/isar.dart';

part 'utxo.g.dart';

@Collection(accessor: "utxos", inheritance: false)
class UTXO {
  UTXO({
    required this.walletId,
    required this.txid,
    required this.vout,
    required this.value,
    required this.name,
    required this.isBlocked,
    required this.blockedReason,
    required this.isCoinbase,
    required this.blockHash,
    required this.blockHeight,
    required this.blockTime,
    this.address,
    this.used,
    this.otherData,
  });

  Id id = Isar.autoIncrement;

  @Index()
  late final String walletId;

  @Index(unique: true, replace: true, composite: [
    CompositeIndex("walletId"),
    CompositeIndex("vout"),
  ])
  late final String txid;

  late final int vout;

  late final int value;

  late final String name;

  @Index()
  late final bool isBlocked;

  late final String? blockedReason;

  late final bool isCoinbase;

  late final String? blockHash;

  late final int? blockHeight;

  late final int? blockTime;

  late final String? address;

  late final bool? used;

  late final String? otherData;

  int getConfirmations(int currentChainHeight) {
    if (blockTime == null || blockHash == null) return 0;
    if (blockHeight == null || blockHeight! <= 0) return 0;
    return max(0, currentChainHeight - (blockHeight! - 1));
  }

  bool isConfirmed(int currentChainHeight, int minimumConfirms) {
    final confirmations = getConfirmations(currentChainHeight);
    return confirmations >= minimumConfirms;
  }

  UTXO copyWith({
    Id? id,
    String? walletId,
    String? txid,
    int? vout,
    int? value,
    String? name,
    bool? isBlocked,
    String? blockedReason,
    bool? isCoinbase,
    String? blockHash,
    int? blockHeight,
    int? blockTime,
    String? address,
    bool? used,
    String? otherData,
  }) =>
      UTXO(
        walletId: walletId ?? this.walletId,
        txid: txid ?? this.txid,
        vout: vout ?? this.vout,
        value: value ?? this.value,
        name: name ?? this.name,
        isBlocked: isBlocked ?? this.isBlocked,
        blockedReason: blockedReason ?? this.blockedReason,
        isCoinbase: isCoinbase ?? this.isCoinbase,
        blockHash: blockHash ?? this.blockHash,
        blockHeight: blockHeight ?? this.blockHeight,
        blockTime: blockTime ?? this.blockTime,
        address: address ?? this.address,
        used: used ?? this.used,
        otherData: otherData ?? this.otherData,
      )..id = id ?? this.id;

  @override
  String toString() => "{ "
      "id: $id, "
      "walletId: $walletId, "
      "txid: $txid, "
      "vout: $vout, "
      "value: $value, "
      "name: $name, "
      "isBlocked: $isBlocked, "
      "blockedReason: $blockedReason, "
      "isCoinbase: $isCoinbase, "
      "blockHash: $blockHash, "
      "blockHeight: $blockHeight, "
      "blockTime: $blockTime, "
      "address: $address, "
      "used: $used, "
      "otherData: $otherData, "
      "}";

  @override
  bool operator ==(Object other) {
    return other is UTXO &&
        other.walletId == walletId &&
        other.txid == txid &&
        other.vout == vout;
  }

  @override
  @ignore
  int get hashCode => Object.hashAll([walletId, txid, vout]);
}