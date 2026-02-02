import 'package:tech_proof/core/network/dio_client.dart';
import 'package:tech_proof/core/network/failure_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DioClient', () {
    test('should have correct base options', () {
      final dioClient = DioClient(apiKey: 'mock_api_key');
      final dio = dioClient.dio;

      expect(dio.options.baseUrl, 'https://api.themoviedb.org/3/');
      expect(dio.options.connectTimeout, const Duration(milliseconds: 5000));
      expect(dio.options.receiveTimeout, const Duration(milliseconds: 5000));
      expect(dio.options.queryParameters['api_key'], 'mock_api_key');
    });

    test('should have interceptors added', () {
      final dioClient = DioClient(apiKey: 'mock_api_key');
      final dio = dioClient.dio;

      expect(
        dio.interceptors.any((element) => element is FailureInterceptor),
        isTrue,
      );
      expect(
        dio.interceptors.any((element) => element is LogInterceptor),
        isTrue,
      );
    });
  });
}
