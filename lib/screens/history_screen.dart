import 'package:flutter/material.dart';
import 'details_screen.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> scannedDataList;

  HistoryScreen({required this.scannedDataList});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> filteredData = [];
  String searchQuery = '';
  String sortOrder = 'Descending'; // Default sorting order

  @override
  void initState() {
    super.initState();
    filteredData = List.from(widget.scannedDataList);
  }

  // Search products by name
  void _filterData(String query) {
    setState(() {
      searchQuery = query;
      filteredData = widget.scannedDataList.where((item) {
        final name = item['name']?.toString().toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
      _sortData(sortOrder); // Reapply sorting
    });
  }

  // Sort products by timestamp
  void _sortData(String order) {
    setState(() {
      sortOrder = order;
      filteredData.sort((a, b) {
        final dateA = DateTime.parse(a['timestamp']);
        final dateB = DateTime.parse(b['timestamp']);
        if (order == 'Ascending') {
          return dateA.compareTo(dateB);
        } else {
          return dateB.compareTo(dateA);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterData,
              decoration: InputDecoration(
                labelText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Sort Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort by Date:',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<String>(
                  value: sortOrder,
                  items: ['Ascending', 'Descending'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _sortData(value);
                    }
                  },
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: filteredData.isEmpty
                ? Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      final name = item['name'] ?? 'Unknown Product';
                      final latitude = item['latitude'] ?? 'N/A';
                      final longitude = item['longitude'] ?? 'N/A';
                      final date = item['timestamp'] ?? 'N/A';

                      return ListTile(
                        leading: Icon(Icons.qr_code),
                        title: Text(name),
                        subtitle: Text(
                          'Date: $date\nLocation: ($latitude, $longitude)',
                        ),
                        onTap: () {
                          // Navigate to the Details Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(data: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
