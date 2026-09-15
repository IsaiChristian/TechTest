import 'package:closer_to_god/core/services/local_storage_service.dart';
import 'package:closer_to_god/core/services/notification_service.dart';
import 'package:closer_to_god/data/repositories/alarm_repository_impl.dart';
import 'package:closer_to_god/data/repositories/subscription_repository_impl.dart';
import 'package:closer_to_god/domain/repositories/alarm_repository.dart';
import 'package:closer_to_god/domain/repositories/subscription_repository.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_bloc.dart';
import 'package:closer_to_god/src/app/bloc/app_bloc.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> repositoryProviders = [
  RepositoryProvider<AlarmRepository>(
    create: (context) => AlarmRepositoryImpl(context.read<LocalStorageService>()),
  ),
  RepositoryProvider<SubscriptionRepository>(
    create: (context) => SubscriptionRepositoryImpl(context.read<LocalStorageService>()),
  ),
];

List<SingleChildWidget> appWideProviders = [
  BlocProvider(create: (context) => AppBloc()),
  BlocProvider(
    create: (context) => AlarmBloc(
      alarmRepository: context.read<AlarmRepository>(),
      notificationService: context.read<NotificationService>(),
    ),
  ),
  BlocProvider(
    create: (context) => PaywallBloc(
      subscriptionRepository: context.read<SubscriptionRepository>(),
    ),
  ),
];
