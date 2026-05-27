class TransactionQrModel {
  final String orderId;
  final String
      actionType; // 'delivery' (Pengantaran) atau 'return' (Pengembalian)
  final String timestamp;

  TransactionQrModel({
    required this.orderId,
    required this.actionType,
    required this.timestamp,
  });

  // Simulasi parsing dari JSON Barcode
  factory TransactionQrModel.fromJson(Map<String, dynamic> json) {
    return TransactionQrModel(
      orderId: json['orderId'] ?? '',
      actionType: json['actionType'] ?? 'delivery',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
