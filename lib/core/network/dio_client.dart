import 'package:tech_proof/core/network/failure_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio _dio;

  Dio get dio => _dio;

  DioClient({String? apiKey}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3/',
        connectTimeout: Duration(milliseconds: 5000),
        receiveTimeout: Duration(milliseconds: 5000),
        queryParameters: {'api_key': apiKey ?? dotenv.env['TMB_API']},
      ),
    );

    _dio.interceptors.add(FailureInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }
}
