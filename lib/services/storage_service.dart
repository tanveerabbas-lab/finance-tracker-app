import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

/// StorageService is responsible for all local (on-device) persistence
/// of the user's financial transactions using SharedPreferences.
/// This is the evidence file for the "Local Storage Implementation" task.
class StorageService {
  static const String _transactionsKey = 'transactions';

  /// Save the full list of transactions to local storage.
  static Future<void> saveTransactions(List<FinanceTransaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(jsonList));
  }

  /// Load the list of transactions from local storage.
  static Future<List<FinanceTransaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_transactionsKey);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.map((e) => FinanceTransaction.fromJson(e)).toList();
  }

  /// Add a single transaction and persist it immediately.
  static Future<void> addTransaction(FinanceTransaction transaction) async {
    final current = await loadTransactions();
    current.insert(0, transaction);
    await saveTransactions(current);
  }

  /// Clear all stored transactions (used for testing / logout).
  static Future<void> clearTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionsKey);
  }
}
