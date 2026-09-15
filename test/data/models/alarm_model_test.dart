import 'package:closer_to_god/data/models/alarm_model.dart';
import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tAlarmModel = AlarmModel(
    id: '1',
    title: 'Morning Prayer',
    hour: 7,
    minute: 30,
    reason: 'Gratitude for family',
    daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
    isEnabled: true,
    voiceDismissalSentence: 'Amen, Lord guide my day',
  );

  test('should be a subclass of AlarmEntity', () {
    expect(tAlarmModel, isA<AlarmEntity>());
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': '1',
        'title': 'Morning Prayer',
        'hour': 7,
        'minute': 30,
        'reason': 'Gratitude for family',
        'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
        'isEnabled': true,
        'voiceDismissalSentence': 'Amen, Lord guide my day',
      };

      final result = AlarmModel.fromJson(jsonMap);

      expect(result, equals(tAlarmModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tAlarmModel.toJson();

      final expectedJsonMap = {
        'id': '1',
        'title': 'Morning Prayer',
        'hour': 7,
        'minute': 30,
        'reason': 'Gratitude for family',
        'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
        'isEnabled': true,
        'voiceDismissalSentence': 'Amen, Lord guide my day',
      };

      expect(result, equals(expectedJsonMap));
    });
  });

  group('formattedTime', () {
    test('should format morning time correctly', () {
      const model = AlarmModel(
        id: '1',
        title: 'Morning Prayer',
        hour: 7,
        minute: 5,
        reason: 'Test',
        daysOfWeek: [1],
      );
      expect(model.formattedTime, equals('7:05 AM'));
    });

    test('should format evening time correctly', () {
      const model = AlarmModel(
        id: '1',
        title: 'Evening Prayer',
        hour: 20,
        minute: 30,
        reason: 'Test',
        daysOfWeek: [1],
      );
      expect(model.formattedTime, equals('8:30 PM'));
    });
  });
}
