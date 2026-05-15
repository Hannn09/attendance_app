import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/history/domain/models/history_data.dart';
import 'package:fpdart/fpdart.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<History>>> getHistory();
}
