enum ProcessStepType {
  received,
  preparing,
  shipping,
  completed,
  returnApplied,
  checking,
  returnCompleted
}

class OrderProcessStepModel {
  final ProcessStepType type;
  final String title;
  final String description;
  final String? time;
  final bool requiresProof;
  final String? proofImageUrl;

  OrderProcessStepModel({
    required this.type,
    required this.title,
    required this.description,
    this.time,
    this.requiresProof = false,
    this.proofImageUrl,
  });
}

class DeliveryDriverModel {
  String deliveryTime;
  String deliveryMethod;
  String driverName;
  String licensePlate;
  String vehicleType;

  DeliveryDriverModel({
    this.deliveryTime = '',
    this.deliveryMethod = 'Diantar Oleh Mitra',
    this.driverName = '',
    this.licensePlate = '',
    this.vehicleType = '',
  });
}
