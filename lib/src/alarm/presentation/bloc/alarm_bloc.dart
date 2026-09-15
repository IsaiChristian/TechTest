import 'package:closer_to_god/core/services/notification_service.dart';
import 'package:closer_to_god/domain/repositories/alarm_repository.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_event.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository alarmRepository;
  final NotificationService notificationService;

  AlarmBloc({
    required this.alarmRepository,
    required this.notificationService,
  }) : super(AlarmInitial()) {
    on<LoadAlarms>(_onLoadAlarms);
    on<AddAlarm>(_onAddAlarm);
    on<ToggleAlarmEvent>(_onToggleAlarm);
    on<DeleteAlarmEvent>(_onDeleteAlarm);
  }

  Future<void> _onLoadAlarms(LoadAlarms event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    final result = await alarmRepository.getAlarms();
    result.fold(
      (failure) => emit(AlarmError(failure.message)),
      (alarms) => emit(AlarmLoaded(alarms)),
    );
  }

  Future<void> _onAddAlarm(AddAlarm event, Emitter<AlarmState> emit) async {
    final result = await alarmRepository.saveAlarm(event.alarm);
    await result.fold(
      (failure) async => emit(AlarmError(failure.message)),
      (_) async {
        await notificationService.scheduleAlarmNotification(event.alarm);
        add(LoadAlarms());
      },
    );
  }

  Future<void> _onToggleAlarm(ToggleAlarmEvent event, Emitter<AlarmState> emit) async {
    final result = await alarmRepository.toggleAlarm(event.id, event.isEnabled);
    await result.fold(
      (failure) async => emit(AlarmError(failure.message)),
      (_) async {
        final alarmsResult = await alarmRepository.getAlarms();
        alarmsResult.fold((_) {}, (alarms) async {
          final target = alarms.firstWhere((a) => a.id == event.id);
          if (event.isEnabled) {
            await notificationService.scheduleAlarmNotification(target);
          } else {
            await notificationService.cancelAlarmNotification(target.id);
          }
        });
        add(LoadAlarms());
      },
    );
  }

  Future<void> _onDeleteAlarm(DeleteAlarmEvent event, Emitter<AlarmState> emit) async {
    final result = await alarmRepository.deleteAlarm(event.id);
    await result.fold(
      (failure) async => emit(AlarmError(failure.message)),
      (_) async {
        await notificationService.cancelAlarmNotification(event.id);
        add(LoadAlarms());
      },
    );
  }
}
