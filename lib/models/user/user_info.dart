// models/user_info.dart
class UserInfo {
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String? officeName;

  UserInfo({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.officeName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      officeName: json['officeName'],
    );
  }
}