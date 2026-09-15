import 'package:closer_to_god/core/services/local_safe_call.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('localSafeCall', () {
    test('should return Right with result on success', () async {
      final result = await localSafeCall(() async => 'success');
      expect(result, const Right('success'));
    });

    test('should return Left with LocalStorageFailure on exception', () async {
      final result = await localSafeCall(() async {
        throw Exception('error');
      });
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<LocalStorageFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });
}
