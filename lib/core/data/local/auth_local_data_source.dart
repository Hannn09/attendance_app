import 'dart:convert';

import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSource({required this.secureStorage});

  static const _token = 'API_TOKEN';
  static const _userId = 'USER_ID';
  static const _user = 'USER_DATA';

  Future<void> cacheUserLoggedin(String token, int userId, Users user) async {
    await secureStorage.write(key: _token, value: token);
    await secureStorage.write(key: _userId, value: userId.toString());
    await secureStorage.write(key: _user, value: jsonEncode(user.toJson()));
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: _token);
  }

  Future<void> clearUserLoggedin() async {
    await secureStorage.delete(key: _token);
    await secureStorage.delete(key: _userId);
    await secureStorage.delete(key: _user);
  }

  Future<Users?> getLoggedInUser() async {
    final userData = await secureStorage.read(key: _user);
    if (userData == null) return null;
    return Users.fromJson(jsonDecode(userData));
  }
}
