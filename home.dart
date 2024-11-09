import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // List of widgets to display for each tab
  final List<Widget> _widgetOptions = <Widget>[
    const Center(
        child: Text('Calendar', style: TextStyle(color: Colors.white))),
    const Center(child: Text('omsim', style: TextStyle(color: Colors.white))),
    const Center(
        child: Text('app dev bading', style: TextStyle(color: Colors.white))),
    const Center(
        child: Text('Profile Page', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
            backgroundColor: Color(0xFF212121),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF212121),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings',
            backgroundColor: Color(0xFF212121),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color(0xFF212121),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellowAccent[700],
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(color: Colors.yellowAccent),
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
