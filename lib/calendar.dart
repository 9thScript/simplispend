import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/appstate.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDay;
  final DateFormat monthFormat = DateFormat('MMMM y');

  void _goToPreviousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      selectedDay = null; // Reset selected day when changing month
    });
  }

  void _goToNextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      selectedDay = null; // Reset selected day when changing month
    });
  }

  void _onDaySelected(int day) {
    setState(() {
      selectedDay = DateTime(selectedDate.year, selectedDate.month, day);
    });
  }

  List<Widget> _buildDaysGrid(int daysInMonth, int startDayOffset) {
    List<Widget> dayWidgets = [];

    // Previous month's dates
    int prevMonthDays = DateTime(selectedDate.year, selectedDate.month, 0).day;
    for (int i = startDayOffset - 1; i >= 0; i--) {
      dayWidgets.add(
        Center(
          child: Text(
            '${prevMonthDays - i}',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Current month dates
    for (int day = 1; day <= daysInMonth; day++) {
      bool isToday = selectedDate.year == DateTime.now().year &&
          selectedDate.month == DateTime.now().month &&
          day == DateTime.now().day;
      bool isSelected = selectedDay != null &&
          selectedDay!.year == selectedDate.year &&
          selectedDay!.month == selectedDate.month &&
          selectedDay!.day == day;

      dayWidgets.add(
        GestureDetector(
          onTap: () => _onDaySelected(day),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue
                    : (isToday ? Colors.grey[700] : Colors.transparent),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isToday ? Colors.white : Colors.grey[300]),
                    fontWeight: isToday || isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Next month's dates
    int remainingCells = 42 - dayWidgets.length;
    for (int i = 1; i <= remainingCells; i++) {
      dayWidgets.add(
        Center(
          child: Text(
            '$i',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return dayWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final remaining = Provider.of<AppState>(context).balance;
    final income = Provider.of<AppState>(context).totalIncome;
    final expense = Provider.of<AppState>(context).totalExpense;

    // Calculate total for selected day, or default to 0 if no day is selected
    double dayIncome = 0;
    double dayExpense = 0;
    double dayRemaining = 0;

    if (selectedDay != null) {
      // Fetch transactions for the selected day
      dayIncome = _getIncomeForSelectedDay(selectedDay!);
      dayExpense = _getExpenseForSelectedDay(selectedDay!);
      dayRemaining = _getRemainingForSelectedDay(selectedDay!);
    }

    int daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    int startDayOffset =
        DateTime(selectedDate.year, selectedDate.month, 1).weekday % 7;

    return Container(
      color: const Color(0xFF1e1e2c), // Set background color
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                'Welcome to the Calendar View!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                'Select the date you wish to view',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF2e2e3a),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Month Navigation Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_left, color: Colors.white),
                          onPressed: _goToPreviousMonth,
                        ),
                        Text(
                          monthFormat.format(selectedDate),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_right, color: Colors.white),
                          onPressed: _goToNextMonth,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Weekday Headers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                    SizedBox(height: 10),
                    // Calendar days
                    SizedBox(
                      height:
                          300, // Fixed height to fit GridView within available space
                      child: GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: _buildDaysGrid(daysInMonth, startDayOffset),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Overview Box (Always present)
              Text(
                selectedDay != null
                    ? 'Selected date overview: ${DateFormat.yMMMd().format(selectedDay!)}'
                    : 'No date selected',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF2e2e3a),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Expense',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "$dayExpense", // Display expense for selected day
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "$dayIncome", // Display income for selected day
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Remaining',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "$dayRemaining", // Display remaining for selected day
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mock data retrieval for income, expense, and remaining balance
  double _getIncomeForSelectedDay(DateTime selectedDay) {
    final income = Provider.of<AppState>(context).totalIncome;
    // Example logic - Replace with your actual data fetching logic
    if (selectedDay.year == 2024 &&
        selectedDay.month == 12 &&
        selectedDay.day == 1) {
      return income; // Example income for Dec 1, 2024
    }
    return 0.0; // Return zero if no data for that day
  }

  double _getExpenseForSelectedDay(DateTime selectedDay) {
    final expense = Provider.of<AppState>(context).totalExpense;
    // Example logic - Replace with your actual data fetching logic
    if (selectedDay.year == 2024 &&
        selectedDay.month == 12 &&
        selectedDay.day == 1) {
      return expense; // Example expense for Dec 1, 2024
    }
    return 0.0; // Return zero if no data for that day
  }

  double _getRemainingForSelectedDay(DateTime selectedDay) {
    // Example logic - Replace with your actual data fetching logic
    double income = _getIncomeForSelectedDay(selectedDay);
    double expense = _getExpenseForSelectedDay(selectedDay);
    return income - expense; // Calculate remaining balance
  }
}
