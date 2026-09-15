import 'package:equatable/equatable.dart';

abstract class PaywallState extends Equatable {
  const PaywallState();

  @override
  List<Object?> get props => [];
}

class PaywallInitial extends PaywallState {}

class PaywallLoading extends PaywallState {}

class PaywallStatusLoaded extends PaywallState {
  final bool isSubscribed;

  const PaywallStatusLoaded(this.isSubscribed);

  @override
  List<Object?> get props => [isSubscribed];
}

class PaywallPurchaseSuccess extends PaywallState {}

class PaywallError extends PaywallState {
  final String message;

  const PaywallError(this.message);

  @override
  List<Object?> get props => [message];
}
