import 'dart:async';

class GlobalErrorBus {
  static final _controller = StreamController<AppError>.broadcast();

  static Stream<AppError> get stream => _controller.stream;

  static void dispatch(AppError error) {
    _controller.add(error);
  }
}

class AppError {
  final String type;
  final String message;
  AppError(this.type, this.message);
}
