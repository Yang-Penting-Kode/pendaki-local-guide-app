// =============================================================================
// 📦 ORDER MODEL — Order penyewaan alat gunung + embedded OrderItemModel
// Lokasi: lib/shared/models/order_model.dart
// Kontrak: fromJson + toJson + copyWith | created_at & updated_at wajib
// Aturan: Semua properti uang WAJIB Decimal (package:decimal) — AI_RULES #3
// =============================================================================

import 'package:decimal/decimal.dart';

import '../enums/app_enums.dart';

class OrderModel {
  final String id;
  final String storeId;
  final String customerId;
  final OrderStatus status;
  final String customerName;
  final String? customerAvatarUrl;
  final DateTime rentalStartDate;
  final DateTime rentalEndDate;
  final Decimal totalGrossPrice;
  final Decimal rentalCost;
  final Decimal depositCost;
  final Decimal platformServiceFee;
  final Decimal deliveryCost; // 🚀 Injeksi Delivery Cost
  final Decimal? taxAmount; // 🚀 PPN
  final Decimal? paymentMethodFee; // 🚀 Biaya Metode Pembayaran
  final String? paymentMethod; // 🚀 Nama Metode Pembayaran
  final Decimal netEarnings;
  final List<OrderItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? rating; // 🚀 Injeksi Rating Ulasan
  final String? reviewText; // 🚀 Injeksi Teks Ulasan
  final String? reviewImageUrl; // 🚀 Injeksi Foto Ulasan

  const OrderModel({
    required this.id,
    required this.storeId,
    required this.customerId,
    required this.status,
    required this.customerName,
    this.customerAvatarUrl,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.totalGrossPrice,
    required this.rentalCost,
    required this.depositCost,
    required this.platformServiceFee,
    required this.deliveryCost, // 🚀
    this.taxAmount,
    this.paymentMethodFee,
    this.paymentMethod,
    required this.netEarnings,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.rating,
    this.reviewText,
    this.reviewImageUrl,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      status: OrderStatus.fromJson(json['status']),
      customerName: json['customer_name'] ?? '',
      customerAvatarUrl: json['customer_avatar_url'],
      rentalStartDate: json['rental_start_date'] != null
          ? DateTime.parse(json['rental_start_date'])
          : DateTime.now(),
      rentalEndDate: json['rental_end_date'] != null
          ? DateTime.parse(json['rental_end_date'])
          : DateTime.now(),
      totalGrossPrice:
          Decimal.parse(json['total_gross_price']?.toString() ?? '0'),
      rentalCost: Decimal.parse(json['rental_cost']?.toString() ?? '0'),
      depositCost: Decimal.parse(json['deposit_cost']?.toString() ?? '0'),
      platformServiceFee:
          Decimal.parse(json['platform_service_fee']?.toString() ?? '0'),
      deliveryCost: Decimal.parse(json['delivery_cost']?.toString() ?? '0'), // 🚀
      taxAmount: json['tax_amount'] != null ? Decimal.parse(json['tax_amount'].toString()) : Decimal.zero,
      paymentMethodFee: json['payment_method_fee'] != null ? Decimal.parse(json['payment_method_fee'].toString()) : Decimal.zero,
      paymentMethod: json['payment_method']?.toString(),
      netEarnings: Decimal.parse(json['net_earnings']?.toString() ?? '0'),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      reviewText: json['review_text']?.toString(),
      reviewImageUrl: json['review_image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'status': status.toJson(),
      'customer_name': customerName,
      'customer_avatar_url': customerAvatarUrl,
      'rental_start_date': rentalStartDate.toIso8601String(),
      'rental_end_date': rentalEndDate.toIso8601String(),
      'total_gross_price': totalGrossPrice.toString(),
      'rental_cost': rentalCost.toString(),
      'deposit_cost': depositCost.toString(),
      'platform_service_fee': platformServiceFee.toString(),
      'delivery_cost': deliveryCost.toString(), // 🚀
      'tax_amount': taxAmount?.toString() ?? '0',
      'payment_method_fee': paymentMethodFee?.toString() ?? '0',
      'payment_method': paymentMethod,
      'net_earnings': netEarnings.toString(),
      'items': items.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rating': rating,
      'review_text': reviewText,
      'review_image_url': reviewImageUrl,
    };
  }

  OrderModel copyWith({
    String? id,
    String? storeId,
    String? customerId,
    OrderStatus? status,
    String? customerName,
    String? customerAvatarUrl,
    DateTime? rentalStartDate,
    DateTime? rentalEndDate,
    Decimal? totalGrossPrice,
    Decimal? rentalCost,
    Decimal? depositCost,
    Decimal? platformServiceFee,
    Decimal? deliveryCost, // 🚀
    Decimal? taxAmount,
    Decimal? paymentMethodFee,
    String? paymentMethod,
    Decimal? netEarnings,
    List<OrderItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    String? reviewText,
    String? reviewImageUrl,
  }) {
    return OrderModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerAvatarUrl: customerAvatarUrl ?? this.customerAvatarUrl,
      rentalStartDate: rentalStartDate ?? this.rentalStartDate,
      rentalEndDate: rentalEndDate ?? this.rentalEndDate,
      totalGrossPrice: totalGrossPrice ?? this.totalGrossPrice,
      rentalCost: rentalCost ?? this.rentalCost,
      depositCost: depositCost ?? this.depositCost,
      platformServiceFee: platformServiceFee ?? this.platformServiceFee,
      deliveryCost: deliveryCost ?? this.deliveryCost, // 🚀
      taxAmount: taxAmount ?? this.taxAmount,
      paymentMethodFee: paymentMethodFee ?? this.paymentMethodFee,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      netEarnings: netEarnings ?? this.netEarnings,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      reviewImageUrl: reviewImageUrl ?? this.reviewImageUrl,
    );
  }

  @override
  String toString() =>
      'OrderModel(id: $id, status: $status, totalGrossPrice: $totalGrossPrice)';
}

// =============================================================================
// 📦 ORDER ITEM MODEL — Item individual di dalam sebuah order
// Embedded di file ini sesuai keputusan arsitektur (tidak file terpisah).
// =============================================================================

class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final Decimal unitPrice;
  final String? variantName;
  final Decimal? variantPrice;
  final Decimal subtotal;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.variantName,
    this.variantPrice,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: Decimal.parse(json['unit_price']?.toString() ?? '0'),
      variantName: json['variant_name']?.toString(),
      variantPrice: json['variant_price'] != null ? Decimal.parse(json['variant_price'].toString()) : null,
      subtotal: Decimal.parse(json['subtotal']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice.toString(),
      'variant_name': variantName,
      'variant_price': variantPrice?.toString(),
      'subtotal': subtotal.toString(),
    };
  }

  OrderItemModel copyWith({
    String? productId,
    String? productName,
    int? quantity,
    Decimal? unitPrice,
    String? variantName,
    Decimal? variantPrice,
    Decimal? subtotal,
  }) {
    return OrderItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      variantName: variantName ?? this.variantName,
      variantPrice: variantPrice ?? this.variantPrice,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  String toString() =>
      'OrderItemModel(productId: $productId, productName: $productName, qty: $quantity)';
}
