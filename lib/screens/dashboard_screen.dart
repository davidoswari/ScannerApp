import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final int totalPackages;
  final int pendingDeliveries;
  final int completedDeliveries;

  DashboardScreen({
    required this.totalPackages,
    required this.pendingDeliveries,
    required this.completedDeliveries,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate efficiency
    final double efficiency = totalPackages == 0
        ? 0
        : (completedDeliveries / totalPackages) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Packages Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Packages',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$totalPackages',
                      style: TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Pending Deliveries Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending Deliveries',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$pendingDeliveries',
                      style: TextStyle(fontSize: 24, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Completed Deliveries Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed Deliveries',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$completedDeliveries',
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Efficiency Progress
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Efficiency',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: efficiency / 100,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 8,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${efficiency.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
