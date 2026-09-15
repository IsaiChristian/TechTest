import 'package:closer_to_god/core/error/failure.dart';
import 'package:closer_to_god/core/error/logger_service.dart';
import 'package:dartz/dartz.dart';

class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.message);
}

Future<Either<Failure, T>> localSafeCall<T>(Future<T> Function() request) async {
  try {
    final result = await request();
    return Right(result);
  } catch (e, st) {
    LoggerService.error("LocalStorage", e.toString(), st);
    return Left(
      LocalStorageFailure(
        "Error accessing local storage: ${e.toString()}",
      ),
    );
  }
}
