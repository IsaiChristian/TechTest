import 'dart:async';

import 'package:tech_proof/core/error/global_error_bus.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late final StreamSubscription _errorSub;
  AppBloc() : super(AppInitial()) {
    _errorSub = GlobalErrorBus.stream.listen((appError) {
      add(AppErrorReceived(appError));
    });

    on<AppErrorReceived>(_onErrorReceived);
  }

  void _onErrorReceived(AppErrorReceived event, Emitter<AppState> emit) {
    final error = event.error;

    switch (error.type) {
      case "unauthorized":
        emit(AppSessionExpired(error.message));
        break;
      case "network":
        emit(AppNetworkError(error.message));
        break;
      case "server_error":
        emit(AppServerError(error.message));
        break;
      default:
        emit(AppUnknownError(error.message));
    }
  }

  @override
  Future<void> close() {
    _errorSub.cancel();
    return super.close();
  }
}
