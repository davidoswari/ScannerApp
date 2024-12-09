import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'qr_scanner_screen.dart';
import 'dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Profile details
  String userName = "John Doe";
  String userRole = "Farmer";

  // Initialize with mock data
  List<Map<String, dynamic>> scannedDataList = [
    {
      "id": "10001",
      "name": "Product A",
      "latitude": -6.21462,
      "longitude": 106.84513,
      "timestamp": "2024-12-01T10:30:00Z",
      "scannedBy": "Alice"
    },
    {
      "id": "10002",
      "name": "Product B",
      "latitude": -7.25747,
      "longitude": 112.75209,
      "timestamp": "2024-12-02T14:45:00Z",
      "scannedBy": "Bob"
    },
    {
      "id": "10003",
      "name": "Product C",
      "latitude": -0.78927,
      "longitude": 113.92133,
      "timestamp": "2024-12-03T09:15:00Z",
      "scannedBy": "Charlie"
    },
    {
      "id": "10004",
      "name": "Product D",
      "latitude": -6.91474,
      "longitude": 107.60981,
      "timestamp": "2024-12-04T17:00:00Z",
      "scannedBy": "Diana"
    },
    {
      "id": "10005",
      "name": "Product E",
      "latitude": -8.34054,
      "longitude": 115.092,
      "timestamp": "2024-12-05T08:00:00Z",
      "scannedBy": "Eve"
    }
  ];

  // Update profile data
  void updateProfile(String newName, String newRole) {
    setState(() {
      userName = newName;
      userRole = newRole;
    });
  }

  // Add scanned data
  void addScannedData(Map<String, dynamic> data) {
    setState(() {
      scannedDataList.add(data);
    });
  }

  // Generate screens dynamically
  List<Widget> getScreens() {
    return [
      DashboardScreen(
        totalPackages: scannedDataList.length,
        pendingDeliveries: scannedDataList.length - 2, // Example pending count
        completedDeliveries: 2, // Example completed count
      ),
      QRScannerScreen(onScanned: addScannedData, userName: userName),
      HistoryScreen(scannedDataList: scannedDataList),
      ProfileScreen(
        userName: userName,
        userRole: userRole,
        onProfileUpdated: updateProfile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "Delivery Management App",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Content for the selected tab
            Expanded(
              child: getScreens()[_currentIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
