// user_model.dart
class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String role; // 'USER', 'MERCHANT', 'COURIER'
  final String? username;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.role,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      username: json['username'],
    );
  }
}
