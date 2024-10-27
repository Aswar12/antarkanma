// lib/app/data/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String role; // 'USER', 'MERCHANT', 'COURIER'
  final String? username;
  final String? profilePhotoUrl;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.role,
    this.username,
    this.profilePhotoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['roles'], // Perhatikan bahwa ini adalah 'roles' dalam JSON
      username: json['username'],
      profilePhotoUrl: json['profile_photo_url'],
    );
  }
}
