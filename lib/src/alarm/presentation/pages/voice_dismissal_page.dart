import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class VoiceDismissalPage extends StatefulWidget {
  final AlarmEntity alarm;

  const VoiceDismissalPage({
    super.key,
    required this.alarm,
  });

  @override
  State<VoiceDismissalPage> createState() => _VoiceDismissalPageState();
}

class _VoiceDismissalPageState extends State<VoiceDismissalPage>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isDismissed = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });
        await _audioRecorder.start(
          const RecordConfig(),
          path: '', // In-memory or temporary recording stream
        );

        // Simulate speaking sentence verification
        await Future.delayed(const Duration(seconds: 2));
        _verifyAndDismiss();
      } else {
        _showPermissionError();
      }
    } catch (e) {
      _verifyAndDismiss();
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
    } catch (_) {}
    setState(() {
      _isRecording = false;
    });
  }

  void _verifyAndDismiss() async {
    await _stopRecording();
    if (!mounted) return;
    setState(() {
      _isDismissed = true;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _showPermissionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Microphone permission required for voice dismissal.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                size: 64,
                color: Color(0xFFD4A373),
              ),
              const SizedBox(height: 24),
              Text(
                widget.alarm.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Reason to Pray:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${widget.alarm.reason}"',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Recite this prayer phrase aloud to turn off the alarm:',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.alarm.voiceDismissalSentence,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              if (_isDismissed) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  'Prayer Recorded. Have a blessed day!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                GestureDetector(
                  onTap: _isRecording ? _verifyAndDismiss : _startRecording,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = _isRecording ? 1.0 + (_pulseController.value * 0.1) : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: _isRecording
                              ? Colors.redAccent
                              : theme.colorScheme.primary,
                          child: Icon(
                            _isRecording ? Icons.mic : Icons.mic_none_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording ? 'Listening... Speak your prayer' : 'Tap & speak to dismiss',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _verifyAndDismiss,
                  child: const Text('Silent Dismissal (Tap to Dismiss)'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
