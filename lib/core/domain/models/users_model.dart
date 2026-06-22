class Users {
  final int id;
  final String? username;
  final String? name;
  final String? role;
  final String? facePicturePath;
  final List<double>? faceEmbedding;

  Users({
    required this.id,
    this.username,
    this.name,
    this.role,
    this.facePicturePath,
    this.faceEmbedding,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      name: json['name'] as String?,
      username: json['username'] as String?,
      role: json['role'] as String?,
      facePicturePath: json['face_picture_path'] as String?,
      faceEmbedding: json['face_embedding'] != null
          ? List<double>.from(json['face_embedding'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role,
      if (facePicturePath != null) 'face_picture_path': facePicturePath,
      if (faceEmbedding != null) 'face_embedding': faceEmbedding,
    };
  }
}
