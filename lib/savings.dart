import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingsScreen extends StatefulWidget {
  @override
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  double savingsGoal = 0;
  double currentSavings = 0;
  DateTime? startDate;
  DateTime? endDate;

  void setGoal(BuildContext context) {
    TextEditingController goalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF23252D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Set Goal",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Goal Amount",
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  savingsGoal =
                      double.tryParse(goalController.text) ?? savingsGoal;
                  if (savingsGoal < 0) savingsGoal = 0;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text(
                "Set Goal",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void incrementSavings(double amount) {
    setState(() {
      currentSavings += amount;
      if (currentSavings > savingsGoal) {
        currentSavings = savingsGoal;
      }
    });
  }

  void selectDateRange(BuildContext context) async {
    DateTime? selectedStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedStartDate != null) {
      DateTime? selectedEndDate = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: selectedStartDate,
        lastDate: DateTime(2101),
      );

      if (selectedEndDate != null) {
        setState(() {
          startDate = selectedStartDate;
          endDate = selectedEndDate;
        });
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    double progress = (savingsGoal > 0) ? currentSavings / savingsGoal : 0;
    List<double> budgetDistribution = calculateBudgetDistribution(savingsGoal);

    return Scaffold(
      backgroundColor: Color(0xFF1e1e2c),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              "Savings Goal: ₱${savingsGoal.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Current Savings: ₱${currentSavings.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFF2e2e3a),
              ),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1 ? Colors.green : Colors.yellow),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setGoal(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: Text(
                    "Set Saving Goal",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    selectDateRange(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: Text(
                    "Select Date Range",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (startDate != null && endDate != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From: ${formatDate(startDate!)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "To: ${formatDate(endDate!)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        savingsGoal = 0;
                        currentSavings = 0;
                        startDate = null;
                        endDate = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Budgeting Type:",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    DropdownButton<String>(
                      dropdownColor: Color(0xFF23252D),
                      value: selectedBudgetType,
                      items: budgetingOptions.keys.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBudgetType = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Horizontal Budget Distribution
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(budgetDistribution.length, (index) {
                    return Flexible(
                      child: Column(
                        children: [
                          Text(
                            "${budgetingOptions[selectedBudgetType]![index]}%",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "₱${budgetDistribution[index].toStringAsFixed(2)}",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      List<double> amounts = [1, 10, 50, 100, 500, 1000];
                      return _buildIncrementButton(amounts[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectedBudgetType = "50/30/20";
  Map<String, List<double>> budgetingOptions = {
    "50/30/20": [50, 30, 20],
    "50/15/5": [50, 15, 5],
    "80/20": [80, 20, 0],
  };

  List<double> calculateBudgetDistribution(double totalAmount) {
    List<double> percentages = budgetingOptions[selectedBudgetType]!;
    return percentages.map((percent) => (totalAmount * percent / 100)).toList();
  }

  Widget _buildIncrementButton(double amount) {
    return ElevatedButton(
      onPressed: () {
        if (amount.isFinite) {
          incrementSavings(amount);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        "+₱${amount.toInt()}",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
