import 'package:closer_to_god/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, bool>> isSubscribed();
  Future<Either<Failure, bool>> purchaseSubscription(String productId);
  Future<Either<Failure, bool>> restorePurchases();
}
