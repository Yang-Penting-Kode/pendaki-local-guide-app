// =============================================================================
// 📦 APP ENUMS — Single Source of Truth untuk semua enum domain
// Lokasi: lib/shared/models/enums/app_enums.dart
// Aturan: DILARANG mendefinisikan enum domain di file lain.
// =============================================================================

/// Status ketersediaan produk rental di toko mitra.
enum ProductStatus {
  active,
  inactiveToday,
  inactiveIndefinitely;

  /// Konversi dari string JSON Supabase/Laravel ke enum.
  /// Contoh value dari API: "active", "inactive_today", "inactive_indefinitely"
  static ProductStatus fromJson(String? value) {
    switch (value) {
      case 'active':
        return ProductStatus.active;
      case 'inactive_today':
        return ProductStatus.inactiveToday;
      case 'inactive_indefinitely':
        return ProductStatus.inactiveIndefinitely;
      default:
        return ProductStatus.active;
    }
  }

  /// Konversi ke string snake_case untuk dikirim ke REST API.
  String toJson() {
    switch (this) {
      case ProductStatus.active:
        return 'active';
      case ProductStatus.inactiveToday:
        return 'inactive_today';
      case ProductStatus.inactiveIndefinitely:
        return 'inactive_indefinitely';
    }
  }
}

/// Status lifecycle order penyewaan alat gunung.
enum OrderStatus {
  awaitingConfirmation,
  activeRental,
  readyForReturn,
  completed,
  cancelled;

  static OrderStatus fromJson(String? value) {
    switch (value) {
      case 'awaiting_confirmation':
        return OrderStatus.awaitingConfirmation;
      case 'active_rental':
        return OrderStatus.activeRental;
      case 'ready_for_return':
        return OrderStatus.readyForReturn;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.awaitingConfirmation;
    }
  }

  String toJson() {
    switch (this) {
      case OrderStatus.awaitingConfirmation:
        return 'awaiting_confirmation';
      case OrderStatus.activeRental:
        return 'active_rental';
      case OrderStatus.readyForReturn:
        return 'ready_for_return';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}

/// Jenis transaksi keuangan mitra.
enum TransactionType {
  income,
  expense,
  withdrawal;

  static TransactionType fromJson(String? value) {
    switch (value) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'withdrawal':
        return TransactionType.withdrawal;
      default:
        return TransactionType.income;
    }
  }

  String toJson() {
    switch (this) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
      case TransactionType.withdrawal:
        return 'withdrawal';
    }
  }
}
