import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/core/network/dio_client.dart';

void main() {
  test('DioClient has LogInterceptor in debug mode', () {
    final dioClient = DioClient(apiKey: 'dummy_key');
    final dio = dioClient.dio;

    final hasLogInterceptor = dio.interceptors.any(
      (element) => element is LogInterceptor,
    );

    expect(
      hasLogInterceptor,
      isTrue,
      reason: 'LogInterceptor should be present in debug mode',
    );
  });
}
