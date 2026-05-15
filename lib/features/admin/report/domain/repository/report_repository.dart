import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/report/domain/models/report_list.dart';
import 'package:fpdart/fpdart.dart';

abstract class ReportRepository {
  Future<Either<Failure, List<ReportList>>> getAllReport();
}
