import 'package:attendance_cnn_app/core/data/local/auth_local_data_source.dart';
import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:attendance_cnn_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRemoteDataSource = Provider(
  (ref) => AuthRemoteDataSource(dio: ref.read(dioProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(
    dataSource: ref.read(authRemoteDataSource),
    localDataSource: ref.read(authLocalDataSource),
  ),
);

final secureStorageProvider = Provider((_) => const FlutterSecureStorage());

final authLocalDataSource = Provider(
  (ref) => AuthLocalDataSource(secureStorage: ref.read(secureStorageProvider)),
);
