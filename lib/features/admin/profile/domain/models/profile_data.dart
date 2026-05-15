class ProfileData {
  final int id;
  final String username;
  final String name;
  final String role;

  ProfileData({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as int,
      username: json['username'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }
}
