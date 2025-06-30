// models/login_response.dart
class LoginResponse {
  final String accessToken;
  final String tokenType;
  final String email;
  final String name;
  final String role;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.email,
    required this.name,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      tokenType: json['tokenType'] ?? 'Bearer',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}