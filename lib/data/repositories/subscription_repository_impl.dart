import 'package:closer_to_god/core/error/failure.dart';
import 'package:closer_to_god/core/services/local_safe_call.dart';
import 'package:closer_to_god/core/services/local_storage_service.dart';
import 'package:closer_to_god/domain/repositories/subscription_repository.dart';
import 'package:dartz/dartz.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  static const String _subKey = 'closer_to_god_is_subscribed';
  final LocalStorageService localStorageService;

  SubscriptionRepositoryImpl(this.localStorageService);

  @override
  Future<Either<Failure, bool>> isSubscribed() async {
    return localSafeCall(() async {
      final isSub = await localStorageService.getBool(_subKey);
      return isSub ?? false;
    });
  }

  @override
  Future<Either<Failure, bool>> purchaseSubscription(String productId) async {
    return localSafeCall(() async {
      // Architecture placeholder for RevenueCat integration:
      // CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      // bool isSubscribed = customerInfo.entitlements.all["pro"]?.isActive ?? false;
      await localStorageService.setBool(_subKey, true);
      return true;
    });
  }

  @override
  Future<Either<Failure, bool>> restorePurchases() async {
    return localSafeCall(() async {
      // Architecture placeholder for RevenueCat restore
      final isSub = await localStorageService.getBool(_subKey) ?? false;
      return isSub;
    });
  }
}
