import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/core/error/global_error_bus.dart';
import 'package:tech_proof/src/app/bloc/app_bloc.dart';

void main() {
  late AppBloc appBloc;

  setUp(() {
    appBloc = AppBloc();
  });

  tearDown(() {
    appBloc.close();
  });

  test('initial state is AppInitial', () {
    expect(appBloc.state, AppInitial());
  });

  blocTest<AppBloc, AppState>(
    'emits [AppSessionExpired] when GlobalErrorBus dispatches unauthorized error',
    build: () => appBloc,
    act: (bloc) => GlobalErrorBus.dispatch(AppError('unauthorized', 'Session expired')),
    expect: () => [
      const AppSessionExpired('Session expired'),
    ],
  );

  blocTest<AppBloc, AppState>(
    'emits [AppNetworkError] when GlobalErrorBus dispatches network error',
    build: () => appBloc,
    act: (bloc) => GlobalErrorBus.dispatch(AppError('network', 'No internet')),
    expect: () => [
      const AppNetworkError('No internet'),
    ],
  );

  blocTest<AppBloc, AppState>(
    'emits [AppServerError] when GlobalErrorBus dispatches server_error',
    build: () => appBloc,
    act: (bloc) => GlobalErrorBus.dispatch(AppError('server_error', 'Server down')),
    expect: () => [
      const AppServerError('Server down'),
    ],
  );

  blocTest<AppBloc, AppState>(
    'emits [AppUnknownError] when GlobalErrorBus dispatches unknown error',
    build: () => appBloc,
    act: (bloc) => GlobalErrorBus.dispatch(AppError('unknown', 'Unknown')),
    expect: () => [
      const AppUnknownError('Unknown'),
    ],
  );
}
