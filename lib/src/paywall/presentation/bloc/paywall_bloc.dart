import 'package:closer_to_god/domain/repositories/subscription_repository.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_event.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  final SubscriptionRepository subscriptionRepository;

  PaywallBloc({required this.subscriptionRepository}) : super(PaywallInitial()) {
    on<CheckSubscriptionStatus>(_onCheckSubscriptionStatus);
    on<PurchasePackage>(_onPurchasePackage);
    on<RestorePurchasesEvent>(_onRestorePurchases);
  }

  Future<void> _onCheckSubscriptionStatus(
    CheckSubscriptionStatus event,
    Emitter<PaywallState> emit,
  ) async {
    emit(PaywallLoading());
    final result = await subscriptionRepository.isSubscribed();
    result.fold(
      (failure) => emit(PaywallError(failure.message)),
      (isSub) => emit(PaywallStatusLoaded(isSub)),
    );
  }

  Future<void> _onPurchasePackage(
    PurchasePackage event,
    Emitter<PaywallState> emit,
  ) async {
    emit(PaywallLoading());
    final result = await subscriptionRepository.purchaseSubscription(event.productId);
    result.fold(
      (failure) => emit(PaywallError(failure.message)),
      (_) => emit(PaywallPurchaseSuccess()),
    );
  }

  Future<void> _onRestorePurchases(
    RestorePurchasesEvent event,
    Emitter<PaywallState> emit,
  ) async {
    emit(PaywallLoading());
    final result = await subscriptionRepository.restorePurchases();
    result.fold(
      (failure) => emit(PaywallError(failure.message)),
      (isSubscribed) => emit(PaywallStatusLoaded(isSubscribed)),
    );
  }
}
