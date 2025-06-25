// lib/models/user_model.dart
class UserModel {
  final String username;
  final String password; // ini sudah di-hash sebelum disimpan
  final String createdAt;

  UserModel({
    required this.username,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'password': password, 'createdAt': createdAt};
  }

  factory UserModel.fromMap(String username, Map<dynamic, dynamic> map) {
    return UserModel(
      username: username,
      password: map['password'],
      createdAt: map['createdAt'],
    );
  }
}
