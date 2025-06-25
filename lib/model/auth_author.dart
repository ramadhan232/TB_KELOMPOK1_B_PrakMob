class AuthAuthor {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? avatarUrl;
  final bool isActive;
  final String token;

  AuthAuthor({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.avatarUrl,
    required this.isActive,
    required this.token,
  });

  factory AuthAuthor.fromJson(Map<String, dynamic> json) {
    final body = json['body'] ?? json;
    final data = body['data'] ?? body;

    // Deteksi apakah data langsung berisi user (dari /me), atau di dalam author (dari /login)
    final user = data.containsKey('author') ? data['author'] : data;

    return AuthAuthor(
      id: user['id'] ?? '',
      email: user['email'] ?? '',
      firstName: user['firstName'] ?? '',
      lastName: user['lastName'] ?? '',
      bio: user['bio'],
      avatarUrl: user['avatarUrl'],
      isActive: user['isActive'] ?? false,
      token: data['token'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
