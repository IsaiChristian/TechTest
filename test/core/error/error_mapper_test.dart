import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/core/error/error_mapper.dart';
import 'package:tech_proof/core/error/failure.dart';

void main() {
  group('mapDioException', () {
    test('should return NetworkFailure on connectionTimeout', () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(result, isA<NetworkFailure>());
    });

    test('should return UnauthorizedFailure on 401', () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
          ),
        ),
      );
      expect(result, isA<UnauthorizedFailure>());
    });

    test('should return ServerFailure on 500', () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
          ),
        ),
      );
      expect(result, isA<ServerFailure>());
    });

    test('should return UnexpectedFailure on default', () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.unknown,
          message: 'error',
        ),
      );
      expect(result, isA<UnexpectedFailure>());
    });
  });
}
