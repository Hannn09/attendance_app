class Users {
  final int id;
  final String? username;
  final String? name;
  final String? role;

  Users({required this.id, this.username, this.name, this.role});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      name: json['name'] as String?,
      username: json['username'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'username': username, 'role': role};
  }
}
