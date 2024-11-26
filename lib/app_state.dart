import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  String userName = '';
  double balance = 0.0;
  double totalExpense = 0.0;
  double totalIncome = 0.0;
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

  // Example method to update balance or other fields
  void updateBalance(double amount, String type) {
    if (type == 'Expense') {
      balance -= amount;
    } else if (type == 'Income') {
      balance += amount;
    }
    notifyListeners();
  }
}
