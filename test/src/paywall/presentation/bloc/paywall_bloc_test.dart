import 'package:bloc_test/bloc_test.dart';
import 'package:closer_to_god/domain/repositories/subscription_repository.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_bloc.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_event.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'paywall_bloc_test.mocks.dart';

@GenerateMocks([SubscriptionRepository])
void main() {
  late PaywallBloc paywallBloc;
  late MockSubscriptionRepository mockSubscriptionRepository;

  setUp(() {
    mockSubscriptionRepository = MockSubscriptionRepository();
    paywallBloc = PaywallBloc(subscriptionRepository: mockSubscriptionRepository);
  });

  test('initial state should be PaywallInitial', () {
    expect(paywallBloc.state, equals(PaywallInitial()));
  });

  blocTest<PaywallBloc, PaywallState>(
    'should emit [PaywallLoading, PaywallStatusLoaded] when CheckSubscriptionStatus is called',
    build: () {
      when(mockSubscriptionRepository.isSubscribed())
          .thenAnswer((_) async => const Right(true));
      return paywallBloc;
    },
    act: (bloc) => bloc.add(CheckSubscriptionStatus()),
    expect: () => [
      PaywallLoading(),
      const PaywallStatusLoaded(true),
    ],
  );
}
