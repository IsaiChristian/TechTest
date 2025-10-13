import 'package:tech_proof/core/error/failure.dart';
import 'package:dio/dio.dart';

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkFailure("No internet connection or timeout");

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) return UnauthorizedFailure("Unauthorized");
      if (statusCode == 404) return ServerFailure("Not found");
      if (statusCode == 500) return ServerFailure("Internal server error");
      return ServerFailure("Server error: $statusCode");

    case DioExceptionType.cancel:
      return UnexpectedFailure("Request cancelled");

    default:
      return UnexpectedFailure("Unexpected error: ${e.message}");
  }
}
