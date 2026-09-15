import 'package:closer_to_god/core/error/failure.dart';
import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AlarmRepository {
  Future<Either<Failure, List<AlarmEntity>>> getAlarms();
  Future<Either<Failure, void>> saveAlarm(AlarmEntity alarm);
  Future<Either<Failure, void>> deleteAlarm(String id);
  Future<Either<Failure, void>> toggleAlarm(String id, bool isEnabled);
}
