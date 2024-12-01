import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double balance = 0.0;
  String currentRank = 'Unranked';
  String userName = "Username";
  Color iconColor = Colors.purple;

  String get _userName => userName;
  String get _currentRank => currentRank;
  Color get _iconColor => iconColor;

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void setRank(String rank) {
    currentRank = rank;
    notifyListeners();
  }

  void updateIconColor(Color newColor) {
    iconColor = newColor;
    notifyListeners();
  }

  void updateBalance(double amount, String type) {
    if (type == 'Income') {
      totalIncome += amount;
      balance += amount;
    } else if (type == 'Expense') {
      totalExpense += amount;
      balance -= amount;
    }

    _updateRank();
    notifyListeners();
  }

  void removeTransaction(double amount, String type) {
    if (type == 'Income') {
      totalIncome -= amount;
      balance -= amount;
    } else if (type == 'Expense') {
      totalExpense -= amount;
      balance += amount;
    }

    _updateRank();
    notifyListeners();
  }

  void _updateRank() {
    if (balance >= 2000) {
      currentRank = 'Platinum';
    } else if (balance >= 1000) {
      currentRank = 'Gold';
    } else if (balance >= 500) {
      currentRank = 'Silver';
    } else if (balance >= 100) {
      currentRank = 'Bronze';
    } else {
      currentRank = 'Unranked';
    }
  }

  getExpenseForDate(DateTime dateTime) {}

  getIncomeForDate(DateTime dateTime) {}

  getBalanceForDate(DateTime dateTime) {}
}
