import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_bloc.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_event.dart';
import 'package:closer_to_god/src/alarm/presentation/bloc/alarm_state.dart';
import 'package:closer_to_god/src/alarm/presentation/pages/voice_dismissal_page.dart';
import 'package:closer_to_god/src/alarm/presentation/widgets/alarm_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({super.key});

  @override
  State<AlarmListPage> createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AlarmBloc>().add(LoadAlarms());
  }

  void _openEditDialog([AlarmEntity? alarm]) async {
    final result = await showDialog<AlarmEntity>(
      context: context,
      builder: (context) => AlarmEditDialog(initialAlarm: alarm),
    );

    if (result != null && mounted) {
      context.read<AlarmBloc>().add(AddAlarm(result));
    }
  }

  void _testDismissal(AlarmEntity alarm) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoiceDismissalPage(alarm: alarm),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CloserToGod'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rounded, color: Color(0xFFD4A373)),
            tooltip: 'Premium',
            onPressed: () {
              context.push('/paywall');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Daily Verse & Inspiration',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"Ask and it will be given to you; seek and you will find; knock and the door will be opened to you."',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '— Matthew 7:7',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<AlarmBloc, AlarmState>(
              builder: (context, state) {
                if (state is AlarmLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is AlarmLoaded) {
                  if (state.alarms.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.alarm_off_rounded, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'No Prayer Alarms Set',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text('Tap + to create your first prayer reminder.'),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final alarm = state.alarms[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        alarm.formattedTime,
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: alarm.isEnabled
                                              ? theme.colorScheme.primary
                                              : Colors.grey,
                                        ),
                                      ),
                                      Switch(
                                        value: alarm.isEnabled,
                                        activeThumbColor: theme.colorScheme.primary,
                                        onChanged: (enabled) {
                                          context
                                              .read<AlarmBloc>()
                                              .add(ToggleAlarmEvent(alarm.id, enabled));
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    alarm.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Reason: "${alarm.reason}"',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton.icon(
                                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                                        label: const Text('Test Dismissal'),
                                        onPressed: () => _testDismissal(alarm),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined),
                                            onPressed: () => _openEditDialog(alarm),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                            onPressed: () {
                                              context
                                                  .read<AlarmBloc>()
                                                  .add(DeleteAlarmEvent(alarm.id));
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.alarms.length,
                    ),
                  );
                } else if (state is AlarmError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Error: ${state.message}')),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text('Add Alarm'),
        onPressed: () => _openEditDialog(),
      ),
    );
  }
}
