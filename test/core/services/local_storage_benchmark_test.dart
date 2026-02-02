import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_proof/core/services/local_storage_service.dart';

// Mock entity for testing
class TestEntity implements JsonConvertible {
  final int id;
  final String name;

  TestEntity({required this.id, required this.name});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  static TestEntity fromJson(Map<String, dynamic> json) {
    return TestEntity(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

void main() {
  test('Benchmark getJsonList with large dataset', () async {
    const itemCount = 5000;
    const key = 'benchmark_key';

    // Generate large dataset
    final List<String> jsonList = List.generate(
      itemCount,
      (index) => jsonEncode({'id': index, 'name': 'Item $index'}),
    );

    // Setup Mock SharedPreferences
    SharedPreferences.setMockInitialValues({key: jsonList});

    final service = LocalStorageService();

    final stopwatch = Stopwatch()..start();
    final result = await service.getJsonList<TestEntity>(
      key,
      TestEntity.fromJson,
    );
    stopwatch.stop();

    expect(result.length, itemCount);
    print('Time taken to parse $itemCount items: ${stopwatch.elapsedMilliseconds}ms');
  });
}
