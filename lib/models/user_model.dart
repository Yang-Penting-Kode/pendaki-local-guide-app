class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? ktpNumber;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.ktpNumber,
    this.isVerified = false,
  });

  // Untuk konversi dari API Laravel Abang
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['name'],
      email: json['email'],
      phoneNumber: json['phone'],
      ktpNumber: json['ktp_number'],
      isVerified: json['email_verified_at'] != null,
    );
  }
}