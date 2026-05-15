import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/core/data/remote/profile_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/profile/data/datasource/profile_user_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/profile/data/repository/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRemoteDataSource = Provider(
  (ref) => ProfileRemoteDataSource(dio: ref.watch(dioProvider)),
);

final profileUserRemoteDataSource = Provider(
  (ref) => ProfileUserRemoteDataSource(dio: ref.watch(dioProvider)),
);

final profileRepository = Provider(
  (ref) => ProfileRepositoryImpl(
    dataSource: ref.watch(profileRemoteDataSource),
    dataSourceUser: ref.watch(profileUserRemoteDataSource),
  ),
);
