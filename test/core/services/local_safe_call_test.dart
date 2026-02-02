import 'package:tech_proof/core/services/local_safe_call.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('safeSharedPreferencesCall', () {
    test('should return Right with result on success', () {
      final result = safeSharedPreferencesCall(() => 'success');
      expect(result, const Right('success'));
    });

    test('should return Left with SharedPreferencesFailure on exception', () {
      final result = safeSharedPreferencesCall(() {
        throw Exception('error');
      });
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<SharedPreferencesFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });
}
