import 'package:tech_proof/core/network/failure_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 5000),
      queryParameters: {'api_key': dotenv.env['TMB_API']},
    ),
  );

  Dio get dio => _dio;

  DioClient() {
    _dio.interceptors.add(FailureInterceptor());

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }
}
