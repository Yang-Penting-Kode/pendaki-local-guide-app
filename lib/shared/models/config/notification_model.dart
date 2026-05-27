class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String category; // 'emergency_rent', 'payment', 'info_market'
  final DateTime timestamp;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timestamp,
  });
}