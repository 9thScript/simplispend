import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/appstate.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalExpense = 0.0;
  double totalIncome = 0.0;
  double balance = 0.0;
  String currentRank = 'Unranked';
  List<Map<String, dynamic>> pieChartSections = [];
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
  }

  void _updateRank() {
    setState(() {
      if (balance >= 2000) {
        currentRank = 'Platinum';
      } else if (balance >= 1000) {
        currentRank = 'Gold';
      } else if (balance >= 500) {
        currentRank = 'Silver';
      } else if (balance >= 100) {
        currentRank = 'Bronze';
      } else {
        currentRank = 'Unranked'; // For balances below 100
      }
    });
  }

  void _removeTransaction(int index) {
    final appState = Provider.of<AppState>(context, listen: false);

    setState(() {
      if (index < transactions.length) {
        var transaction = transactions[index];
        transactions.removeAt(index);
        pieChartSections.removeAt(index);

        appState.removeTransaction(
          double.parse(transaction['amount']),
          transaction['type'],
        );
      }
    });
  }

  void _addSection() async {
    Map<String, dynamic>? result = await _showAddTransactionDialog();

    if (result != null) {
      setState(() {
        String transactionName = result['name'];
        double transactionValue = result['value'];
        String transactionType = result['type'];
        Color newColor =
            Colors.primaries[pieChartSections.length % Colors.primaries.length];

        pieChartSections.add({
          'name': transactionName,
          'section': PieChartSectionData(
            value: transactionValue,
            color: newColor,
            radius: 30,
            showTitle: false,
          ),
        });
        transactions.add({
          'label': transactionName,
          'amount': transactionValue.toStringAsFixed(2),
          'color': newColor,
          'type': transactionType,
        });

        if (transactionType == 'Expense') {
          totalExpense += transactionValue;
          balance -= transactionValue;
        } else if (transactionType == 'Income') {
          totalIncome += transactionValue;
          balance += transactionValue;
        }

        final appState = Provider.of<AppState>(context, listen: false);
        appState.updateBalance(transactionValue,
            transactionType); // Update rank based on the new balance
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Header(rank: appState.currentRank),
            DataSection(),
            BalanceSection(balance: appState.balance),
            ChartSection(
              pieChartSections: pieChartSections,
              onAddTransaction: _addSection,
            ),
            SummarySection(
                totalExpense: appState.totalExpense,
                totalIncome: appState.totalIncome),
            TransactionsSection(
              transactions: transactions,
              onRemoveTransaction: _removeTransaction,
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _showAddTransactionDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    String? transactionType;
    bool isFormValid = false;

    void validateForm() {
      setState(() {
        isFormValid = nameController.text.isNotEmpty &&
            valueController.text.isNotEmpty &&
            transactionType != null &&
            double.tryParse(valueController.text) != null;
      });
    }

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('New Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter transaction name',
                    ),
                    onChanged: (value) => setDialogState(validateForm),
                  ),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter transaction value',
                    ),
                    onChanged: (value) => setDialogState(validateForm),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Expense',
                              style: TextStyle(fontSize: 15)),
                          value: 'Expense',
                          groupValue: transactionType,
                          onChanged: (value) {
                            setDialogState(() {
                              transactionType = value;
                              validateForm();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Income',
                              style: TextStyle(fontSize: 15)),
                          value: 'Income',
                          groupValue: transactionType,
                          onChanged: (value) {
                            setDialogState(() {
                              transactionType = value;
                              validateForm();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  onPressed: isFormValid
                      ? () {
                          double? value = double.tryParse(valueController.text);
                          if (value != null && transactionType != null) {
                            Navigator.of(context).pop({
                              'name': nameController.text,
                              'value': value,
                              'type': transactionType,
                            });
                          }
                        }
                      : null,
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  final String rank;

  const Header({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: appState.iconColor,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 25,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello ${appState.userName}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'Rank: $rank', // Use the dynamic rank
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BalanceSection extends StatelessWidget {
  final double balance;

  const BalanceSection({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        'Balance: ${balance.toStringAsFixed(2)}',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class DataSection extends StatelessWidget {
  const DataSection({super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMMM d, yyyy (EEEE)', 'en_US').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        formattedDate,
        style: TextStyle(color: Colors.yellow, fontSize: 20),
      ),
    );
  }
}

class ChartSection extends StatelessWidget {
  final List<Map<String, dynamic>> pieChartSections;
  final VoidCallback onAddTransaction;

  const ChartSection({
    super.key,
    required this.pieChartSections,
    required this.onAddTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Legend(pieChartSections: pieChartSections), // Legend at the top
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                padding: EdgeInsets.all(1),
                child: PieChart(
                  PieChartData(
                    sections: pieChartSections.map((section) {
                      return section['section'] as PieChartSectionData;
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40, // Leave space for the button
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onAddTransaction, // Trigger adding a transaction
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFFFCC00),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: 36,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Legend extends StatelessWidget {
  final List<Map<String, dynamic>> pieChartSections;

  const Legend({super.key, required this.pieChartSections});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15, // Space between legend items
        runSpacing: 10, // Space between lines if wrapped
        children: pieChartSections.map((section) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: section['section'].color,
                ),
              ),
              SizedBox(width: 5),
              Text(
                section['name'], // Display name of the section
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  final double totalExpense;
  final double totalIncome;

  const SummarySection({
    super.key,
    required this.totalExpense,
    required this.totalIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SummaryBox(
                label: 'Expense',
                amount: totalExpense.toStringAsFixed(2),
                color: Colors.red,
              ),
              SummaryBox(
                label: 'Income',
                amount: totalIncome.toStringAsFixed(2),
                color: Colors.green,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 15), // Add spacing
          child: Text(
            'Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class SummaryBox extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const SummaryBox(
      {super.key,
      required this.label,
      required this.amount,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: Color(0xFF2e2e3a),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontSize: 16),
          ),
          Text(
            amount,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class TransactionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(int) onRemoveTransaction;

  const TransactionsSection({
    super.key,
    required this.transactions,
    required this.onRemoveTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transactions.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> transaction = entry.value;
        return TransactionItem(
          label: transaction['label'],
          amount: transaction['amount'],
          color: transaction['color'],
          transactionType:
              transaction['type'], // Pass the transaction type here
          onRemove: () => onRemoveTransaction(index),
        );
      }).toList(),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final String transactionType; // Add a transactionType property
  final VoidCallback onRemove;

  const TransactionItem({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    required this.transactionType, // Include this property
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xFF2e2e3a),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: transactionType == 'Income'
                      ? Colors.green
                      : Colors.red, // Dynamic text color
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onRemove, // Correctly triggers the remove function
              ),
            ],
          ),
        ],
      ),
    );
  }
}
