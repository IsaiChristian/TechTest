import 'package:tech_proof/core/error/error_mapper.dart';
import 'package:tech_proof/core/error/global_error_bus.dart';
import 'package:tech_proof/core/error/logger_service.dart';
import 'package:dio/dio.dart';

class FailureInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final message =
        err.response?.data.toString() ?? err.message ?? "Unknown Dio error";

    LoggerService.error("Dio", message, err.stackTrace);

    if (statusCode == 401) {
      GlobalErrorBus.dispatch(AppError("unauthorized", "Session expired"));
    } else if (statusCode == 500) {
      GlobalErrorBus.dispatch(
        AppError("server_error", "Internal Server Error"),
      );
    } else if (statusCode == 404) {
      GlobalErrorBus.dispatch(AppError("server_error", "Resource Not Found"));
    } else if (err.type == DioExceptionType.connectionTimeout) {
      GlobalErrorBus.dispatch(AppError("network", "Connection Timeout"));
    }
    final failure = mapDioException(err);

    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: failure,
      message: err.message,
    );
    handler.next(newError);
  }
}
