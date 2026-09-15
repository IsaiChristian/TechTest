import 'package:closer_to_god/core/services/local_storage_service.dart';
import 'package:closer_to_god/data/repositories/subscription_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'subscription_repository_impl_test.mocks.dart';

@GenerateMocks([LocalStorageService])
void main() {
  late SubscriptionRepositoryImpl repository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() {
    mockLocalStorageService = MockLocalStorageService();
    repository = SubscriptionRepositoryImpl(mockLocalStorageService);
  });

  test('isSubscribed should return false when not subscribed', () async {
    when(mockLocalStorageService.getBool(any)).thenAnswer((_) async => false);

    final result = await repository.isSubscribed();

    expect(result.isRight(), isTrue);
    result.fold(
      (l) => fail('Should not fail'),
      (isSub) => expect(isSub, isFalse),
    );
  });

  test('purchaseSubscription should update subscription state in local storage', () async {
    when(mockLocalStorageService.setBool(any, any)).thenAnswer((_) async => true);

    final result = await repository.purchaseSubscription('annual_pro');

    expect(result.isRight(), isTrue);
    verify(mockLocalStorageService.setBool(any, true)).called(1);
  });
}
