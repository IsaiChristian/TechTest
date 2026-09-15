import 'package:closer_to_god/src/alarm/presentation/pages/alarm_list_page.dart';
import 'package:closer_to_god/src/onboarding/presentation/pages/onboarding_page.dart';
import 'package:closer_to_god/src/paywall/presentation/pages/paywall_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const AlarmListPage(),
    ),
    GoRoute(
      name: 'paywall',
      path: '/paywall',
      builder: (context, state) => const PaywallPage(),
    ),
  ],
);
