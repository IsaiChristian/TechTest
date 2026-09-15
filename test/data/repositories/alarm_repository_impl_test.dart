import 'package:closer_to_god/core/services/local_storage_service.dart';
import 'package:closer_to_god/data/repositories/alarm_repository_impl.dart';
import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'alarm_repository_impl_test.mocks.dart';

@GenerateMocks([LocalStorageService])
void main() {
  late AlarmRepositoryImpl repository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() {
    mockLocalStorageService = MockLocalStorageService();
    repository = AlarmRepositoryImpl(mockLocalStorageService);
  });

  const tAlarm = AlarmEntity(
    id: '1',
    title: 'Morning Prayer',
    hour: 7,
    minute: 30,
    reason: 'Gratitude',
    daysOfWeek: [1, 2, 3],
  );

  group('getAlarms', () {
    test('should return empty list when no alarms stored in LocalStorageService', () async {
      when(mockLocalStorageService.getStringList(any))
          .thenAnswer((_) async => null);

      final result = await repository.getAlarms();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should not fail'),
        (r) => expect(r, isEmpty),
      );
    });
  });

  group('saveAlarm', () {
    test('should save alarm into LocalStorageService', () async {
      when(mockLocalStorageService.getStringList(any))
          .thenAnswer((_) async => []);
      when(mockLocalStorageService.setStringList(any, any))
          .thenAnswer((_) async => true);

      final result = await repository.saveAlarm(tAlarm);

      expect(result.isRight(), isTrue);
      verify(mockLocalStorageService.setStringList(any, any)).called(1);
    });
  });
}
