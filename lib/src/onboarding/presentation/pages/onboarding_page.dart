import 'package:closer_to_god/core/services/notification_service.dart';
import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:closer_to_god/domain/repositories/alarm_repository.dart';
import 'package:closer_to_god/domain/repositories/subscription_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  final TextEditingController _reasonController = TextEditingController(
    text: "Gratitude for my family and guidance for the day",
  );
  final TextEditingController _voicePhraseController = TextEditingController(
    text: "Amen, Lord guide my day",
  );

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _requestPermission() async {
    final service = NotificationService();
    await service.requestPermissions();
    _nextPage();
  }

  Future<void> _completeOnboarding() async {
    final alarmRepository = context.read<AlarmRepository>();
    final notificationService = context.read<NotificationService>();

    final firstAlarm = AlarmEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Morning Prayer',
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      reason: _reasonController.text.trim().isEmpty
          ? 'Remember to be close to God'
          : _reasonController.text.trim(),
      daysOfWeek: const [1, 2, 3, 4, 5, 6, 7],
      voiceDismissalSentence: _voicePhraseController.text.trim().isEmpty
          ? 'Amen, Lord guide my day'
          : _voicePhraseController.text.trim(),
    );

    await alarmRepository.saveAlarm(firstAlarm);
    await notificationService.scheduleAlarmNotification(firstAlarm);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomeStep(theme),
                  _buildPermissionStep(theme),
                  _buildAlarmSetupStep(theme),
                  _buildPaywallStep(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.church_rounded,
            size: 96,
            color: Color(0xFFD4A373),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to CloserToGod',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Set daily prayer alarms to pause, give thanks, and keep God at the center of your daily life.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: _nextPage,
              child: const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_active_rounded,
            size: 96,
            color: Color(0xFFC86D51),
          ),
          const SizedBox(height: 32),
          Text(
            'Stay Faithful with Reminders',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Allow notifications so your prayer alarms ring on time, reminding you to pause and speak with God.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: _requestPermission,
              child: const Text('Enable Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmSetupStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set Your First Prayer Alarm',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null) {
                setState(() {
                  _selectedTime = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _selectedTime.format(context),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason to Pray',
              border: OutlineInputBorder(),
              hintText: 'e.g. Gratitude for family',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _voicePhraseController,
            decoration: const InputDecoration(
              labelText: 'Voice Dismissal Phrase (Recite to Turn Off)',
              border: OutlineInputBorder(),
              hintText: 'e.g. Amen, Lord guide my day',
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: _nextPage,
              child: const Text('Next Step', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaywallStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            size: 80,
            color: Color(0xFFD4A373),
          ),
          const SizedBox(height: 24),
          Text(
            'Unlock Premium Devotions',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Unlimited prayer alarms, custom voice dismissals & daily Bible motivation quotes.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Yearly Plan (7-Day Free Trial)'),
                Text('\$19.99/yr', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: () async {
                final subRepo = context.read<SubscriptionRepository>();
                await subRepo.purchaseSubscription('yearly_pro');
                _completeOnboarding();
              },
              child: const Text('Start Free Trial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _completeOnboarding,
            child: const Text('Continue with Free Version'),
          ),
        ],
      ),
    );
  }
}
