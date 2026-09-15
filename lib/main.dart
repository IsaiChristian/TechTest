import 'package:closer_to_god/core/di/core_providers.dart';
import 'package:closer_to_god/core/di/repository_providers.dart';
import 'package:closer_to_god/core/error/logger_service.dart';
import 'package:closer_to_god/core/router/router.dart';
import 'package:closer_to_god/core/services/local_storage_service.dart';
import 'package:closer_to_god/core/theme/app_theme.dart';
import 'package:closer_to_god/src/app/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  try {
    await dotenv.load(fileName: "secrets/.env");
  } catch (_) {
    // Graceful fallback if secrets file is absent in production build
  }

  FlutterError.onError = (details) {
    LoggerService.error("Global", details.exceptionAsString(), details.stack);
  };
  runApp(const CloserToGodApp());
}

class CloserToGodApp extends StatelessWidget {
  const CloserToGodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: coreProviders,
      child: MultiRepositoryProvider(
        providers: repositoryProviders,
        child: MultiBlocProvider(
          providers: appWideProviders,
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.dark,
                routerConfig: router,
                title: 'CloserToGod Prayer Alarm',
              );
            },
          ),
        ),
      ),
    );
  }
}
