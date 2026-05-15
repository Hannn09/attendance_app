import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/report/data/datasource/report_data_source.dart';
import 'package:attendance_cnn_app/features/admin/report/domain/models/report_list.dart';
import 'package:attendance_cnn_app/features/admin/report/domain/repository/report_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportDataSource dataSource;

  ReportRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ReportList>>> getAllReport() async {
    try {
      final response = await dataSource.getAllReport();
      return Right(response.data);
    } on DioException catch (e) {
      throw Failure(
        e.response?.data['message'] as String? ??
            'An unexpected error occurred',
      );
    } catch (e) {
      throw Failure("Data format error: $e");
    }
  }
}
