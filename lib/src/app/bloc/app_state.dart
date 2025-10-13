part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class AppInitial extends AppState {}

final class AppSessionExpired extends AppState {
  final String message;
  const AppSessionExpired(this.message);

  @override
  List<Object> get props => [message];
}

final class AppNetworkError extends AppState {
  final String message;
  const AppNetworkError(this.message);

  @override
  List<Object> get props => [message];
}

final class AppServerError extends AppState {
  final String message;
  const AppServerError(this.message);

  @override
  List<Object> get props => [message];
}

final class AppUnknownError extends AppState {
  final String message;
  const AppUnknownError(this.message);

  @override
  List<Object> get props => [message];
}
