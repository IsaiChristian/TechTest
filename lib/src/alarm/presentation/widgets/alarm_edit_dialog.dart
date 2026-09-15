import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:flutter/material.dart';

class AlarmEditDialog extends StatefulWidget {
  final AlarmEntity? initialAlarm;

  const AlarmEditDialog({
    super.key,
    this.initialAlarm,
  });

  @override
  State<AlarmEditDialog> createState() => _AlarmEditDialogState();
}

class _AlarmEditDialogState extends State<AlarmEditDialog> {
  late TimeOfDay _time;
  late TextEditingController _titleController;
  late TextEditingController _reasonController;
  late TextEditingController _voicePhraseController;
  late List<int> _selectedDays;

  final Map<int, String> _dayLabels = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAlarm;
    _time = initial != null
        ? TimeOfDay(hour: initial.hour, minute: initial.minute)
        : const TimeOfDay(hour: 7, minute: 30);
    _titleController = TextEditingController(text: initial?.title ?? 'Prayer Time');
    _reasonController = TextEditingController(
      text: initial?.reason ?? 'Gratitude for strength and family',
    );
    _voicePhraseController = TextEditingController(
      text: initial?.voiceDismissalSentence ?? 'Amen, Lord guide my day',
    );
    _selectedDays = initial != null ? List.from(initial.daysOfWeek) : [1, 2, 3, 4, 5, 6, 7];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    _voicePhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.initialAlarm == null ? 'New Prayer Alarm' : 'Edit Prayer Alarm'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _time,
                );
                if (picked != null) {
                  setState(() {
                    _time = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _time.format(context),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Reason to Pray',
                hintText: 'e.g. Ask for guidance in work & peace at home',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _voicePhraseController,
              decoration: const InputDecoration(
                labelText: 'Voice Dismissal Phrase',
                hintText: 'e.g. Amen, Lord guide my day',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Repeat Days:', style: theme.textTheme.labelLarge),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: _dayLabels.entries.map((entry) {
                final day = entry.key;
                final label = entry.value;
                final isSelected = _selectedDays.contains(day);
                return FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newAlarm = AlarmEntity(
              id: widget.initialAlarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              title: _titleController.text.trim().isEmpty ? 'Prayer Time' : _titleController.text.trim(),
              hour: _time.hour,
              minute: _time.minute,
              reason: _reasonController.text.trim().isEmpty ? 'Remember to be close to God' : _reasonController.text.trim(),
              daysOfWeek: _selectedDays.isEmpty ? [1, 2, 3, 4, 5, 6, 7] : _selectedDays,
              isEnabled: widget.initialAlarm?.isEnabled ?? true,
              voiceDismissalSentence: _voicePhraseController.text.trim().isEmpty ? 'Amen, Lord guide my day' : _voicePhraseController.text.trim(),
            );
            Navigator.of(context).pop(newAlarm);
          },
          child: const Text('Save Alarm'),
        ),
      ],
    );
  }
}
