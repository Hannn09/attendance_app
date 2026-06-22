import 'dart:io';

class EmployeeModel {
  final int id;
  final String username;
  final String name;
  final String? role;
  final String? facePicturePath;
  final String? password;
  final File? facePictureFile;
  final List<double>? faceEmbedding;

  EmployeeModel({
    required this.id,
    required this.username,
    required this.name,
    this.role,
    this.facePicturePath,
    this.password,
    this.facePictureFile,
    this.faceEmbedding,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
      facePicturePath: json['face_picture_path'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'username': username,
      'name': name,
      'role': 'karyawan',
    };

    if (facePicturePath != null) {
      json['face_picture_path'] = facePicturePath!;
    }

    if (password != null) {
      json['password'] = password!;
    }

    if (faceEmbedding != null) {
      json['face_embedding'] = faceEmbedding!;
    }

    return json;
  }
}
