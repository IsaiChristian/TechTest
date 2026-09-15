import 'package:closer_to_god/core/network/failure_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  late final Dio _dio;

  Dio get dio => _dio;

  DioClient({String? apiKey}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.closertogod.app/v1/',
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 5000),
        queryParameters: {'api_key': apiKey ?? dotenv.env['API_KEY'] ?? ''},
      ),
    );

    _dio.interceptors.add(FailureInterceptor());

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }
}
