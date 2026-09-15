import 'package:bloc_test/bloc_test.dart';
import 'package:closer_to_god/core/services/notification_service.dart';
import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:closer_to_god/domain/repositories/alarm_repository.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_bloc.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_event.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'alarm_bloc_test.mocks.dart';

@GenerateMocks([AlarmRepository, NotificationService])
void main() {
  late AlarmBloc alarmBloc;
  late MockAlarmRepository mockAlarmRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockAlarmRepository = MockAlarmRepository();
    mockNotificationService = MockNotificationService();
    alarmBloc = AlarmBloc(
      alarmRepository: mockAlarmRepository,
      notificationService: mockNotificationService,
    );
  });

  const tAlarm = AlarmEntity(
    id: '1',
    title: 'Morning Prayer',
    hour: 7,
    minute: 0,
    reason: 'Gratitude',
    daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
  );

  test('initial state should be AlarmInitial', () {
    expect(alarmBloc.state, equals(AlarmInitial()));
  });

  blocTest<AlarmBloc, AlarmState>(
    'should emit [AlarmLoading, AlarmLoaded] when LoadAlarms is successful',
    build: () {
      when(mockAlarmRepository.getAlarms())
          .thenAnswer((_) async => const Right([tAlarm]));
      return alarmBloc;
    },
    act: (bloc) => bloc.add(LoadAlarms()),
    expect: () => [
      AlarmLoading(),
      const AlarmLoaded([tAlarm]),
    ],
  );
}
