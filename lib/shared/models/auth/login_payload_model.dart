class LoginPayloadModel {
  final String email;
  final String password;

  const LoginPayloadModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
