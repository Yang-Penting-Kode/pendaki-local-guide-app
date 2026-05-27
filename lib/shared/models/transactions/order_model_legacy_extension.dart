import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';

extension LegacyOrderModelGetters on OrderModel {
  String get mainTitle => items.isNotEmpty ? items.first.productName : 'Pesanan Tanpa Alat';
  String get mainImageUrl => 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=200';
  String get dateRangeDisplay {
    final diff = rentalEndDate.difference(rentalStartDate).inDays;
    return '${rentalStartDate.day} Okt - ${rentalEndDate.day} Okt 2023 (${diff == 0 ? 1 : diff} Hari)';
  }
  String get totalGrossPriceDisplay => 'Rp ${totalGrossPrice.toString()}';
  String get rentalCostDisplay => 'Rp ${rentalCost.toString()}';
  String get depositCostDisplay => 'Rp ${depositCost.toString()}';
  String get platformServiceFeeDisplay => '- Rp ${platformServiceFee.toString()}';
  String get netEarningsDisplay => 'Rp ${netEarnings.toString()}';

  List<RentalItemModel> get rentalItems {
    return items.map((i) => RentalItemModel(
      name: i.productName,
      description: 'Detail',
      quantityDisplay: '${i.quantity}x',
      priceDisplay: 'Rp ${i.subtotal.toString()}'
    )).toList();
  }
}

class RentalItemModel {
  final String name;
  final String description;
  final String quantityDisplay;
  final String priceDisplay;

  const RentalItemModel({
    required this.name,
    required this.description,
    required this.quantityDisplay,
    required this.priceDisplay,
  });
}
