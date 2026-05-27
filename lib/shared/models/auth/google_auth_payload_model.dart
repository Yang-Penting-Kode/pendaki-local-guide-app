class GoogleAuthPayloadModel {
  final String idToken;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const GoogleAuthPayloadModel({
    required this.idToken,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  // Digunakan untuk dikirim ke Laravel API 'POST /api/auth/google'
  Map<String, dynamic> toJson() {
    return {
      'id_token': idToken,
      'email': email,
    };
  }
}
