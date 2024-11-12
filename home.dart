import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _buttonX = 20;
  double _buttonY = 20;
  double totalExpense = 0.0;
  double totalIncome = 0.0;
  double balance = 0.0;
  List<Map<String, dynamic>> pieChartSections = [];
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
  }

  // Method to remove a transaction and update balance accordingly
  void _removeTransaction(int index) {
    setState(() {
      if (index < transactions.length) {
        // Access transaction details
        Map<String, dynamic> transaction = transactions[index];
        double amount = double.tryParse(transaction['amount']) ?? 0.0;
        String type = transaction['type'];

        // Update total values and balance based on transaction type
        if (type == 'Expense') {
          totalExpense -= amount;
          balance += amount; // Add back expense amount to balance
        } else if (type == 'Income') {
          totalIncome -= amount;
          balance -= amount; // Subtract income amount from balance
        }

        // Remove transaction from the transaction list and pie chart sections
        transactions.removeAt(index);
        if (index < pieChartSections.length) {
          pieChartSections.removeAt(index);
        }
      }
    });
  }

  // Prompt for initial balance
  void _showInitialBalanceDialog() {
    TextEditingController balanceController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissal until a value is entered
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Initial Balance'),
          content: TextField(
            controller: balanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter initial balance'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Set Balance'),
              onPressed: () {
                setState(() {
                  balance = double.tryParse(balanceController.text) ?? 0.0;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to add a new section to the pie chart
  void _addSection() async {
    Map<String, dynamic>? result = await _showAddTransactionDialog();

    if (result != null) {
      setState(() {
        String transactionName = result['name'];
        double transactionValue = result['value'];
        String transactionType = result['type'];
        Color newColor =
            Colors.primaries[pieChartSections.length % Colors.primaries.length];

        // Add transaction to chart and transactions list
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
        });

        // Update income or expense total and balance
        if (transactionType == 'Expense') {
          totalExpense += transactionValue;
          balance -= transactionValue; // Subtract from balance for expenses
        } else if (transactionType == 'Income') {
          totalIncome += transactionValue;
          balance += transactionValue; // Add to balance for income
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1e1e2c),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Header(),
                DataSection(),
                BalanceSection(balance: balance),
                ChartSection(pieChartSections: pieChartSections),
                SummarySection(
                    totalExpense: totalExpense, totalIncome: totalIncome),
                TransactionsSection(
                  transactions: transactions,
                  onRemoveTransaction: _removeTransaction,
                ),
              ],
            ),
          ),
          Positioned(
            left: _buttonX,
            top: _buttonY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // Update the button's position based on drag details
                  _buttonX += details.delta.dx;
                  _buttonY += details.delta.dy;
                });
              },
              child: FloatingActionButton(
                onPressed: _addSection,
                backgroundColor: Color(0xFFFFCC00),
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show a dialog for adding a new transaction with name, value, and type
  Future<Map<String, dynamic>?> _showAddTransactionDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    String? transactionType;
    bool isFormValid = false;

    // Function to check form validity
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
          // Use StatefulBuilder to handle dialog state changes
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('New Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter transaction name',
                    ),
                    onChanged: (value) => setDialogState(validateForm),
                  ),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter transaction value',
                    ),
                    onChanged: (value) => setDialogState(validateForm),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title:
                              Text('Expense', style: TextStyle(fontSize: 15)),
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
                          title: Text('Income', style: TextStyle(fontSize: 15)),
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
                  child: Text('Cancel'),
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
                  child: Text('Add'), // Disabled if form is invalid
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
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(left: 20, top: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://placehold.co/50x50'),
            radius: 25,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Kimberly',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'Rank: Silver',
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

  const ChartSection({super.key, required this.pieChartSections});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Legend(pieChartSections: pieChartSections),
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
                centerSpaceRadius: 40,
              ),
            ),
          ),
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
                section['name'], // Display name instead of value
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
    return Padding(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...transactions.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> transaction = entry.value;
            return TransactionItem(
              label: transaction['label'],
              amount: transaction['amount'],
              color: transaction['color'],
              onRemove: () => onRemoveTransaction(index),
            );
          }),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final VoidCallback onRemove;

  const TransactionItem({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
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
                style: TextStyle(color: color, fontSize: 16),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onRemove, // Correctly binds the remove function
              ),
            ],
          ),
        ],
      ),
    );
  }
}
