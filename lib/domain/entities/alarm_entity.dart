import 'package:equatable/equatable.dart';

class AlarmEntity extends Equatable {
  final String id;
  final String title;
  final int hour;
  final int minute;
  final String reason;
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final bool isEnabled;
  final String voiceDismissalSentence;

  const AlarmEntity({
    required this.id,
    required this.title,
    required this.hour,
    required this.minute,
    required this.reason,
    required this.daysOfWeek,
    this.isEnabled = true,
    this.voiceDismissalSentence = "Amen, Lord guide my day",
  });

  String get formattedTime {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  AlarmEntity copyWith({
    String? id,
    String? title,
    int? hour,
    int? minute,
    String? reason,
    List<int>? daysOfWeek,
    bool? isEnabled,
    String? voiceDismissalSentence,
  }) {
    return AlarmEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      reason: reason ?? this.reason,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isEnabled: isEnabled ?? this.isEnabled,
      voiceDismissalSentence: voiceDismissalSentence ?? this.voiceDismissalSentence,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        hour,
        minute,
        reason,
        daysOfWeek,
        isEnabled,
        voiceDismissalSentence,
      ];
}
