import 'dart:convert';
import 'package:closer_to_god/core/error/failure.dart';
import 'package:closer_to_god/core/services/local_safe_call.dart';
import 'package:closer_to_god/core/services/local_storage_service.dart';
import 'package:closer_to_god/data/models/alarm_model.dart';
import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:closer_to_god/domain/repositories/alarm_repository.dart';
import 'package:dartz/dartz.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  static const String _alarmsKey = 'closer_to_god_alarms_v1';
  final LocalStorageService localStorageService;

  AlarmRepositoryImpl(this.localStorageService);

  @override
  Future<Either<Failure, List<AlarmEntity>>> getAlarms() async {
    return localSafeCall(() async {
      final jsonStringList = await localStorageService.getStringList(_alarmsKey);
      if (jsonStringList == null || jsonStringList.isEmpty) {
        return <AlarmEntity>[];
      }
      final alarms = jsonStringList.map((item) {
        final Map<String, dynamic> jsonMap = jsonDecode(item);
        return AlarmModel.fromJson(jsonMap);
      }).toList();
      return alarms;
    });
  }

  @override
  Future<Either<Failure, void>> saveAlarm(AlarmEntity alarm) async {
    return localSafeCall(() async {
      final currentResult = await getAlarms();
      List<AlarmEntity> currentList = [];
      currentResult.fold((l) => null, (r) => currentList = List.from(r));

      final index = currentList.indexWhere((a) => a.id == alarm.id);
      if (index >= 0) {
        currentList[index] = alarm;
      } else {
        currentList.add(alarm);
      }

      final stringList = currentList
          .map((a) => jsonEncode(AlarmModel.fromEntity(a).toJson()))
          .toList();
      await localStorageService.setStringList(_alarmsKey, stringList);
    });
  }

  @override
  Future<Either<Failure, void>> deleteAlarm(String id) async {
    return localSafeCall(() async {
      final currentResult = await getAlarms();
      List<AlarmEntity> currentList = [];
      currentResult.fold((l) => null, (r) => currentList = List.from(r));

      currentList.removeWhere((a) => a.id == id);

      final stringList = currentList
          .map((a) => jsonEncode(AlarmModel.fromEntity(a).toJson()))
          .toList();
      await localStorageService.setStringList(_alarmsKey, stringList);
    });
  }

  @override
  Future<Either<Failure, void>> toggleAlarm(String id, bool isEnabled) async {
    return localSafeCall(() async {
      final currentResult = await getAlarms();
      List<AlarmEntity> currentList = [];
      currentResult.fold((l) => null, (r) => currentList = List.from(r));

      final index = currentList.indexWhere((a) => a.id == id);
      if (index >= 0) {
        currentList[index] = currentList[index].copyWith(isEnabled: isEnabled);
        final stringList = currentList
            .map((a) => jsonEncode(AlarmModel.fromEntity(a).toJson()))
            .toList();
        await localStorageService.setStringList(_alarmsKey, stringList);
      }
    });
  }
}
