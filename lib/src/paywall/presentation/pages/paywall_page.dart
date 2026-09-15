import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_bloc.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_event.dart';
import 'package:closer_to_god/src/paywall/presentation/bloc/paywall_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  String _selectedOption = 'annual';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CloserToGod Premium'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: BlocListener<PaywallBloc, PaywallState>(
        listener: (context, state) {
          if (state is PaywallPurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Subscription activated! God bless you.')),
            );
            Navigator.of(context).pop();
          } else if (state is PaywallError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 72,
                  color: Color(0xFFD4A373),
                ),
                const SizedBox(height: 16),
                Text(
                  'Deepen Your Prayer Life',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock full spiritual features & unlimited prayer alarms',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildFeatureRow(theme, Icons.alarm_add_rounded, 'Unlimited Prayer Alarms'),
                _buildFeatureRow(theme, Icons.mic_rounded, 'Voice Prayer Dismissals'),
                _buildFeatureRow(theme, Icons.menu_book_rounded, 'Daily Bible Inspiration & Devotions'),
                const SizedBox(height: 32),
                _buildPlanCard(
                  theme: theme,
                  id: 'annual',
                  title: 'Annual Plan (Most Popular)',
                  subtitle: '7-day Free Trial, then \$19.99/year',
                  price: '\$1.66/mo',
                ),
                const SizedBox(height: 12),
                _buildPlanCard(
                  theme: theme,
                  id: 'monthly',
                  title: 'Monthly Plan',
                  subtitle: 'Billed monthly',
                  price: '\$2.99/mo',
                ),
                const SizedBox(height: 32),
                BlocBuilder<PaywallBloc, PaywallState>(
                  builder: (context, state) {
                    if (state is PaywallLoading) {
                      return const CircularProgressIndicator();
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          context.read<PaywallBloc>().add(PurchasePackage(_selectedOption));
                        },
                        child: const Text(
                          'Subscribe Now',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.read<PaywallBloc>().add(RestorePurchasesEvent());
                  },
                  child: const Text('Restore Purchases'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Privacy Policy • Terms of Service',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required ThemeData theme,
    required String id,
    required String title,
    required String subtitle,
    required String price,
  }) {
    final isSelected = _selectedOption == id;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedOption = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Text(
              price,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
