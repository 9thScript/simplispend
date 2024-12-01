import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  String userName = '';
  Map<String, double> balanceByDate = {}; // Store balance by date
  Map<String, double> totalExpenseByDate = {}; // Store total expense by date
  Map<String, double> totalIncomeByDate = {}; // Store total income by date
  String currentRank = 'Unranked';
  Color iconColor = Colors.blue;

  // Fetch the username from Firebase
  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userName = user.displayName ??
          'Guest'; // Fallback to 'Guest' if no username is set
      notifyListeners();
    }
  }

  // Method to update transaction data for a specific date
  void updateTransactionForDate(DateTime date, double amount, String type) {
    String dateString =
        date.toIso8601String().split('T')[0]; // Use date as string

    if (type == 'Expense') {
      totalExpenseByDate[dateString] =
          (totalExpenseByDate[dateString] ?? 0.0) + amount;
      balanceByDate[dateString] = (balanceByDate[dateString] ?? 0.0) - amount;
    } else if (type == 'Income') {
      totalIncomeByDate[dateString] =
          (totalIncomeByDate[dateString] ?? 0.0) + amount;
      balanceByDate[dateString] = (balanceByDate[dateString] ?? 0.0) + amount;
    }
    notifyListeners();
  }

  // Fetch the data for a specific date
  double getBalanceForDate(DateTime date) {
    String dateString =
        date.toIso8601String().split('T')[0]; // Use date as string
    return balanceByDate[dateString] ??
        0.0; // Return 0 if no data exists for that date
  }

  double getExpenseForDate(DateTime date) {
    String dateString =
        date.toIso8601String().split('T')[0]; // Use date as string
    return totalExpenseByDate[dateString] ??
        0.0; // Return 0 if no data exists for that date
  }

  double getIncomeForDate(DateTime date) {
    String dateString =
        date.toIso8601String().split('T')[0]; // Use date as string
    return totalIncomeByDate[dateString] ??
        0.0; // Return 0 if no data exists for that date
  }
}
