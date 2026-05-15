import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/admin/report/data/datasource/report_data_source.dart';
import 'package:attendance_cnn_app/features/admin/report/data/repository/report_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportRemoteDataSource = Provider(
  (ref) => ReportDataSource(dio: ref.read(dioProvider)),
);

final reportRepositoryProvider = Provider(
  (ref) => ReportRepositoryImpl(dataSource: ref.read(reportRemoteDataSource)),
);
