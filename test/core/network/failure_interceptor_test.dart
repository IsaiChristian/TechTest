import 'dart:async';

import 'package:tech_proof/core/error/global_error_bus.dart';
import 'package:tech_proof/core/network/failure_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeErrorInterceptorHandler extends ErrorInterceptorHandler {
  DioException? nextError;
  @override
  void next(DioException err) {
    nextError = err;
  }
}

void main() {
  late FailureInterceptor failureInterceptor;
  late FakeErrorInterceptorHandler handler;

  setUp(() {
    failureInterceptor = FailureInterceptor();
    handler = FakeErrorInterceptorHandler();
  });

  group('FailureInterceptor', () {
    test('should dispatch unauthorized error on 401', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
        ),
      );

      final expectation = expectLater(
        GlobalErrorBus.stream,
        emits(predicate<AppError>((e) => e.type == 'unauthorized' && e.message == 'Session expired')),
      );

      failureInterceptor.onError(dioException, handler);

      await expectation;
      expect(handler.nextError, isNotNull);
    });

    test('should dispatch server error on 500', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
        ),
      );

      final expectation = expectLater(
        GlobalErrorBus.stream,
        emits(predicate<AppError>((e) => e.type == 'server_error' && e.message == 'Internal Server Error')),
      );

      failureInterceptor.onError(dioException, handler);

      await expectation;
    });

    test('should dispatch resource not found on 404', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ),
      );

      final expectation = expectLater(
        GlobalErrorBus.stream,
        emits(predicate<AppError>((e) => e.type == 'server_error' && e.message == 'Resource Not Found')),
      );

      failureInterceptor.onError(dioException, handler);

      await expectation;
    });

    test('should dispatch network error on connection timeout', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );

      final expectation = expectLater(
        GlobalErrorBus.stream,
        emits(predicate<AppError>((e) => e.type == 'network' && e.message == 'Connection Timeout')),
      );

      failureInterceptor.onError(dioException, handler);

      await expectation;
    });

    test('should call handler.next with wrapped error', () {
       final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      failureInterceptor.onError(dioException, handler);

      expect(handler.nextError, isNotNull);
      expect(handler.nextError!.error, isNotNull); // The failure mapped
    });
  });
}
