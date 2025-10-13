import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/core/error/logger_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

Future<Either<Failure, T>> safeCall<T>(Future<T> Function() request) async {
  try {
    final result = await request();
    return Right(result);
  } on DioException catch (e) {
    final failure = UnexpectedFailure(e.message ?? "Dio Exception");
    LoggerService.error("Repository", failure.message, e.stackTrace);
    if (e.error is Failure) return Left(e.error as Failure);
    return Left(UnexpectedFailure("Unhandled Dio error: ${e.message}"));
  } catch (e, st) {
    LoggerService.error("Repository", e.toString(), st);

    return Left(UnexpectedFailure(e.toString()));
  }
}
