// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Benchmark: LogInterceptor performance impact', () async {
    final dio = Dio();

    // Mock Adapter that returns a large JSON response
    final largeData = List.generate(
      1000,
      (index) => {
        'id': index,
        'name': 'Item $index',
        'description':
            'This is a long description to make the response body larger and increase logging overhead.',
      },
    );
    final jsonResponse = jsonEncode(largeData);

    // We use an interceptor to mock the response at the beginning of the chain
    // to avoid using the real adapter logic which might be complex to mock perfectly with IOHttpClientAdapter
    // Actually, Dio's HttpClientAdapter is an abstract class, let's implement a simple MockAdapter
    dio.httpClientAdapter = MockAdapter(jsonResponse);

    // 1. Measure with LogInterceptor
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    final stopwatchWithLog = Stopwatch()..start();
    for (int i = 0; i < 100; i++) {
      await dio.get('/test');
    }
    stopwatchWithLog.stop();
    print(
      'Time with LogInterceptor: ${stopwatchWithLog.elapsedMilliseconds}ms',
    );

    // 2. Measure without LogInterceptor
    dio.interceptors.clear(); // Remove all interceptors
    // We need to re-add the mock adapter logic if it was implemented via interceptor,
    // but here we set it on dio.httpClientAdapter, so it persists.

    final stopwatchWithoutLog = Stopwatch()..start();
    for (int i = 0; i < 100; i++) {
      await dio.get('/test');
    }
    stopwatchWithoutLog.stop();
    print(
      'Time without LogInterceptor: ${stopwatchWithoutLog.elapsedMilliseconds}ms',
    );

    final improvement =
        stopwatchWithLog.elapsedMilliseconds -
        stopwatchWithoutLog.elapsedMilliseconds;
    print('Improvement: ${improvement}ms');

    expect(
      stopwatchWithoutLog.elapsedMilliseconds,
      lessThan(stopwatchWithLog.elapsedMilliseconds),
    );
  });
}

class MockAdapter implements HttpClientAdapter {
  final String responseBody;

  MockAdapter(this.responseBody);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      responseBody,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
