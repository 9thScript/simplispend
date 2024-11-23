import 'package:flutter/material.dart';
import 'package:project/appstate.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String currentRank = "Gold"; // Default rank
  Color iconColor = Colors.blue; // Default icon color

  Widget _buildRankIcon(String currentRank) {
    IconData rankIcon;
    Color rankColor;

    switch (currentRank) {
      case "Platinum":
        rankIcon = Icons.star;
        rankColor = Colors.grey[300]!;
        break;
      case "Gold":
        rankIcon = Icons.star;
        rankColor = Colors.yellow;
        break;
      case "Silver":
        rankIcon = Icons.star;
        rankColor = Colors.white;
        break;
      case "Bronze":
        rankIcon = Icons.star_half;
        rankColor = Colors.orange;
        break;
      default:
        rankIcon = Icons.person;
        rankColor = Colors.grey;
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: rankColor,
      child: Icon(
        rankIcon,
        color: Colors.black,
        size: 30,
      ),
    );
  }

  void _showRanksDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF23252D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Ranks Overview",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRankRow("Platinum", 2000, Colors.grey[300]!),
              _buildRankRow("Gold", 1000, Colors.yellow),
              _buildRankRow("Silver", 500, Colors.white),
              _buildRankRow("Bronze", 100, Colors.orange),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRankRow(String rank, int points, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rank,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "$points points",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void openEditDialog() {
    TextEditingController nameController =
        TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF23252D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Edit Account",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name Field
              TextField(
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Profile Icon with Change Color Option
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: iconColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      _openColorPicker();
                    },
                    child: Text(
                      "Change Icon Color",
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without saving
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  userName = nameController.text; // Save the new name
                });
                Provider.of<AppState>(context, listen: false)
                    .setUserName(nameController.text);
                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF23252D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Pick Icon Color",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildColorOption(Colors.red),
              _buildColorOption(Colors.blue),
              _buildColorOption(Colors.green),
              _buildColorOption(Colors.yellow),
              _buildColorOption(Colors.purple),
              _buildColorOption(Colors.orange),
              _buildColorOption(Colors.pink),
              _buildColorOption(Colors.teal),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.updateIconColor(color); // Update icon color in appState
        Navigator.pop(context); // Close the color picker dialog
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Color(0xFF1e1e2c), // Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF23252D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: appState.iconColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      appState.userName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Current Rank Card with Matching Style
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF23252D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildRankIcon(appState.currentRank),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Rank:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF6C942),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appState.currentRank,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _showRanksDialog,
                    child: Text(
                      "View Ranks",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAAAAA),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Buttons
            ProfileButton(
              icon: Icons.edit,
              color: Colors.yellow,
              text: "Edit Account",
              onTap: openEditDialog,
            ),
            const SizedBox(height: 16),
            ProfileButton(
              icon: Icons.delete,
              color: Colors.red,
              text: "Delete Account",
              onTap: () {
                // Handle Delete Account
              },
            ),
            const SizedBox(height: 16),
            ProfileButton(
              icon: Icons.logout,
              color: Colors.red,
              text: "Logout",
              onTap: () {
                // Handle Logout
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Button Widget
class ProfileButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onTap;

  const ProfileButton({
    required this.icon,
    required this.color,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF23252D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
