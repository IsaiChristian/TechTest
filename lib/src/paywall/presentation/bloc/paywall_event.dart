import 'package:equatable/equatable.dart';

abstract class PaywallEvent extends Equatable {
  const PaywallEvent();

  @override
  List<Object?> get props => [];
}

class CheckSubscriptionStatus extends PaywallEvent {}

class PurchasePackage extends PaywallEvent {
  final String productId;

  const PurchasePackage(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RestorePurchasesEvent extends PaywallEvent {}
