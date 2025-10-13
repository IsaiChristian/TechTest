part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppErrorReceived extends AppEvent {
  final AppError error;
  const AppErrorReceived(this.error);

  @override
  List<Object> get props => [error];
}
