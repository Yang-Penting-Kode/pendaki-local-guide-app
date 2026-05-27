// =============================================================================
// 📦 TRANSACTION MODEL — Catatan transaksi keuangan mitra
// Lokasi: lib/shared/models/transaction_model.dart
// Kontrak: fromJson + toJson + copyWith | created_at & updated_at wajib
// Aturan: amount WAJIB Decimal (package:decimal) — AI_RULES #3
// =============================================================================

import 'package:decimal/decimal.dart';

import '../enums/app_enums.dart';

class TransactionModel {
  final String id;
  final String? orderId;
  final String storeId;
  final TransactionType type;
  final Decimal amount;
  final String? description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionModel({
    required this.id,
    this.orderId,
    required this.storeId,
    required this.type,
    required this.amount,
    this.description,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString(),
      storeId: json['store_id']?.toString() ?? '',
      type: TransactionType.fromJson(json['type']),
      amount: Decimal.parse(json['amount']?.toString() ?? '0'),
      description: json['description'],
      transactionDate: json['transaction_date'] != null
          ? DateTime.parse(json['transaction_date'])
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'store_id': storeId,
      'type': type.toJson(),
      'amount': amount.toString(),
      'description': description,
      'transaction_date': transactionDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TransactionModel copyWith({
    String? id,
    String? orderId,
    String? storeId,
    TransactionType? type,
    Decimal? amount,
    String? description,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      storeId: storeId ?? this.storeId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'TransactionModel(id: $id, type: $type, amount: $amount)';
}
