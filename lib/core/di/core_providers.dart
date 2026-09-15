import 'package:closer_to_god/core/network/dio_client.dart';
import 'package:closer_to_god/core/services/local_storage_service.dart';
import 'package:closer_to_god/core/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> coreProviders = [
  Provider<DioClient>(create: (_) => DioClient()),
  Provider<LocalStorageService>(create: (_) => LocalStorageService()),
  Provider<NotificationService>(create: (_) => NotificationService()),
];
