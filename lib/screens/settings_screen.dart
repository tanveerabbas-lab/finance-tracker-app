import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

/// Settings screen: app preferences, live currency exchange rates
/// (fetched from the external API), and notification controls.
/// This is the evidence file for the "Settings Screen Implementation" task.
class SettingsScreen extends StatefulWidget {
  final int initialTabIndex;
  const SettingsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  Map<String, double>? _rates;
  String? _apiError;
  bool _loadingRates = false;
  String? _notificationStatus;

  @override
  void initState() {
    super.initState();
    if (widget.initialTabIndex == 1) _fetchRates();
  }

  Future<void> _fetchRates() async {
    setState(() {
      _loadingRates = true;
      _apiError = null;
    });
    try {
      // Fetched data from the external API -> capture as evidence-api-ux.png/.jpg
      final rates = await ApiService.fetchExchangeRates('USD');
      setState(() => _rates = rates);
    } catch (e) {
      setState(() => _apiError = 'Could not load rates: $e');
    } finally {
      setState(() => _loadingRates = false);
    }
  }

  Future<void> _configureNotifications() async {
    await NotificationService.configureBudgetAlerts();
    setState(() => _notificationStatus =
    'Budget alert channel configured.'); // -> evidence-notification-configure
  }

  Future<void> _sendTestNotification() async {
    await NotificationService.showTestNotification();
    setState(() => _notificationStatus =
    'Test notification sent — check your notification tray.'); // -> evidence-notification-alert
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Preferences', style: Theme.of(context).textTheme.titleMedium),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          const Divider(height: 32),

          Text('Currency Exchange Rates (base: USD)',
              style: Theme.of(context).textTheme.titleMedium),
          const Text(
            'Reference tool for travel/comparison — your transactions are always tracked in Rs.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _loadingRates ? null : _fetchRates,
            icon: const Icon(Icons.refresh),
            label: const Text('Fetch Latest Rates'),
          ),
          if (_loadingRates) const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
          if (_apiError != null)
            Text(_apiError!, style: const TextStyle(color: Colors.red)),
          if (_rates != null)
            ...(_rates!.entries.take(6).map(
                  (e) => ListTile(
                dense: true,
                leading: const Icon(Icons.currency_exchange),
                title: Text(e.key),
                trailing: Text(e.value.toStringAsFixed(4)),
              ),
            )),
          const Divider(height: 32),

          Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _configureNotifications,
            icon: const Icon(Icons.tune),
            label: const Text('Configure Budget Alerts'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _sendTestNotification,
            icon: const Icon(Icons.notifications_active),
            label: const Text('Send Test Notification'),
          ),
          if (_notificationStatus != null) ...[
            const SizedBox(height: 12),
            Text(_notificationStatus!,
                style: const TextStyle(color: Colors.teal)),
          ],
        ],
      ),
    );
  }
}
