import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For platform channel

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  DetailsScreen({required this.data});

  // Platform channel for opening URLs
  static const platform = MethodChannel('com.example.scanner/openUrl');

  // Generate Google Maps URL
  String getGoogleMapsUrl() {
    return 'https://www.google.com/maps?q=${data['latitude']},${data['longitude']}';
  }

  // Open URL using platform channel
  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      await platform.invokeMethod('openUrl', {'url': url});
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open link: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String mapsUrl = getGoogleMapsUrl();

    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title
            Text(
              'Scanned Item Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Display Each Field
            ...data.entries.map((entry) {
              final key = entry.key[0].toUpperCase() + entry.key.substring(1); // Capitalize key
              final value = entry.value.toString(); // Convert value to string
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$key: ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 16),

            // Google Maps Link
            if (data.containsKey('latitude') && data.containsKey('longitude'))
              GestureDetector(
                onTap: () => _openUrl(context, mapsUrl),
                child: Text(
                  'Open in Google Maps',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
