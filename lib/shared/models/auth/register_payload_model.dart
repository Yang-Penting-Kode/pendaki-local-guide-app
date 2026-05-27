class RegisterPayloadModel {
  String fullName;
  String whatsappNumber;
  String email;
  String password;
  String passwordConfirmation;
  String shopName;
  String gender;

  // Menampung path berkas lokal (XFile / File path perangkat asli) sebelum diunggah ke cloud
  String? localLogoPath;
  String? localKtpPath;
  bool isFaceVerified;

  // Koordinat geografis hasil tagging leaflet/OSM map picker
  double? latitude;
  double? longitude;
  String? textAddress;

  RegisterPayloadModel({
    this.fullName = '',
    this.whatsappNumber = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.shopName = '',
    this.gender = 'Laki-laki',
    this.localLogoPath,
    this.localKtpPath,
    this.isFaceVerified = false,
    this.latitude,
    this.longitude,
    this.textAddress,
  });

  // Digunakan oleh Service/Repository API multi-part untuk mengisi form data request payload
  Map<String, String> toMultipartFields() {
    return {
      'name': fullName,
      'phone': whatsappNumber,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'shop_name': shopName,
      'gender': gender,
      'latitude': latitude?.toString() ?? '',
      'longitude': longitude?.toString() ?? '',
      'address_display': textAddress ?? '',
    };
  }
}
