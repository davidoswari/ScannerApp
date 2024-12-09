import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For platform channel

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  DetailsScreen({required this.data});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  static const platform = MethodChannel('com.example.scanner/openUrl');
  late TextEditingController _notesController;
  String? savedNotes;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with existing notes or an empty string
    _notesController = TextEditingController(text: widget.data['notes'] ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Generate Google Maps URL
  String getGoogleMapsUrl() {
    return 'https://www.google.com/maps?q=${widget.data['latitude']},${widget.data['longitude']}';
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

  // Save notes
  void _saveNotes() {
    setState(() {
      savedNotes = _notesController.text;
      widget.data['notes'] = savedNotes; // Save notes to the item's data
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notes saved successfully!')),
    );
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

            // Display Each Field (Exclude "notes")
            ...widget.data.entries
                .where((entry) => entry.key != 'notes') // Exclude the 'notes' key
                .map((entry) {
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
            if (widget.data.containsKey('latitude') && widget.data.containsKey('longitude'))
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

            SizedBox(height: 16),

            // Notes Section
            Text(
              'Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your notes here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: _saveNotes,
              child: Text('Save Notes'),
            ),
          ],
        ),
      ),
    );
  }
}
