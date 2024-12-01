import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  void _showBudgetingInfo(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1e1e2c),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22, // Increased font size for title
              fontWeight: FontWeight.bold, // Optional: to make title bold
            ),
          ),
          content: SingleChildScrollView(
            // Added to make content scrollable
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18, // Increased font size for content
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Adjusted font size for close button
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        title: const Text('Budgeting Tips'),
        backgroundColor: const Color(0xFF1e1e2c),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showBudgetingInfo(
                  context,
                  '50/30/20 Rule',
                  'The 50/30/20 rule divides your income into three categories:\n\n'
                      '1. 50% for Needs: Spend this on essentials like rent, utilities, groceries, and transportation. '
                      'Start by listing these expenses to ensure you are within the 50% mark.\n\n'
                      '2. 30% for Wants: Allocate this portion to discretionary spending like dining out, entertainment, '
                      'and non-essential shopping. To implement this, consider setting aside this amount for treats or hobbies.\n\n'
                      '3. 20% for Savings/Debt Repayment: Use this portion to build an emergency fund, save for future goals, '
                      'or pay off debt. Automate savings or payments to make this consistent in your routine.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text(
                '50/30/20 Rule',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showBudgetingInfo(
                  context,
                  '80/20 Rule',
                  'The 80/20 rule focuses on simplicity and flexibility:\n\n'
                      '1. 80% for Expenses: Use 80% of your income for all living costs, including bills, groceries, and leisure. '
                      'Ensure you track these expenses to prevent overspending.\n\n'
                      '2. 20% for Savings/Investments: Save or invest the remaining 20% for long-term financial goals. '
                      'You can start by automating a portion of your paycheck into a savings account or investment plan.\n\n'
                      'This rule is ideal for those who prefer an easy-to-follow budget without too many categories.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text(
                '80/20 Rule',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showBudgetingInfo(
                  context,
                  '50/15/5 Rule',
                  'The 50/15/5 rule is geared toward long-term financial stability:\n\n'
                      '1. 50% for Essentials: Dedicate half your income to necessities like housing, utilities, food, and healthcare.\n\n'
                      '2. 15% for Retirement Savings: Set aside 15% of your income for retirement accounts, such as 401(k) or IRA. '
                      'If you can, take advantage of employer matching to maximize your contributions.\n\n'
                      '3. 5% for Short-Term Savings: Reserve 5% for immediate financial goals, like vacation funds or emergency expenses. '
                      'You can start by setting up a separate savings account for these purposes.\n\n'
                      'The remaining 30% can be used for discretionary spending, ensuring a balanced approach to financial planning.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text(
                '50/15/5 Rule',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
