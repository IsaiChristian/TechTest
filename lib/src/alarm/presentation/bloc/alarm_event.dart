import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlarms extends AlarmEvent {}

class AddAlarm extends AlarmEvent {
  final AlarmEntity alarm;

  const AddAlarm(this.alarm);

  @override
  List<Object?> get props => [alarm];
}

class ToggleAlarmEvent extends AlarmEvent {
  final String id;
  final bool isEnabled;

  const ToggleAlarmEvent(this.id, this.isEnabled);

  @override
  List<Object?> get props => [id, isEnabled];
}

class DeleteAlarmEvent extends AlarmEvent {
  final String id;

  const DeleteAlarmEvent(this.id);

  @override
  List<Object?> get props => [id];
}
