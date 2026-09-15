import 'package:closer_to_god/domain/entities/alarm_entity.dart';

class AlarmModel extends AlarmEntity {
  const AlarmModel({
    required super.id,
    required super.title,
    required super.hour,
    required super.minute,
    required super.reason,
    required super.daysOfWeek,
    super.isEnabled,
    super.voiceDismissalSentence,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Prayer Time',
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      reason: json['reason'] as String? ?? 'Remember to be close to God',
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [1, 2, 3, 4, 5, 6, 7],
      isEnabled: json['isEnabled'] as bool? ?? true,
      voiceDismissalSentence: json['voiceDismissalSentence'] as String? ?? "Amen, Lord guide my day",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hour': hour,
      'minute': minute,
      'reason': reason,
      'daysOfWeek': daysOfWeek,
      'isEnabled': isEnabled,
      'voiceDismissalSentence': voiceDismissalSentence,
    };
  }

  factory AlarmModel.fromEntity(AlarmEntity entity) {
    return AlarmModel(
      id: entity.id,
      title: entity.title,
      hour: entity.hour,
      minute: entity.minute,
      reason: entity.reason,
      daysOfWeek: entity.daysOfWeek,
      isEnabled: entity.isEnabled,
      voiceDismissalSentence: entity.voiceDismissalSentence,
    );
  }
}
