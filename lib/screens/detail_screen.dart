import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'home_screen.dart' show formatPKR;

/// Detail screen: displays full information for a single transaction.
class DetailScreen extends StatelessWidget {
  final FinanceTransaction transaction;

  const DetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM d, yyyy - h:mm a');

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Detail')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.currency_rupee, 'Amount',
                formatPKR(transaction.amount)),
            _detailRow(Icons.category, 'Category', transaction.category),
            _detailRow(Icons.swap_vert, 'Type', transaction.type.toUpperCase()),
            _detailRow(Icons.calendar_today, 'Date',
                dateFormat.format(transaction.date)),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
