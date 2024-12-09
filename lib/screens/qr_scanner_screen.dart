import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'details_screen.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onScanned;
  final String userName;

  QRScannerScreen({required this.onScanned, required this.userName});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? scannedData;
  bool showSuccess = false;

  // Fetch current geolocation
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  void _handleQRScanned(String code) async {
    setState(() {
      scannedData = code;
      showSuccess = true;
    });

    // Fetch location
    Position? position = await _getCurrentLocation();
    final double latitude = position?.latitude ?? 0.0;
    final double longitude = position?.longitude ?? 0.0;
    final String timestamp = DateTime.now().toIso8601String();

    // Parse the scanned data
    Map<String, dynamic> parsedData;
    try {
      // Attempt to decode JSON
      parsedData = json.decode(code) as Map<String, dynamic>;
    } catch (e) {
      // Fallback for non-JSON data
      parsedData = {"rawData": code};
    }

    // Add additional metadata to the parsed data
    final scannedItem = {
      ...parsedData,
      "latitude": latitude,
      "longitude": longitude,
      "timestamp": timestamp,
      "scannedBy": widget.userName,
    };

    // Add scanned data to history
    widget.onScanned(scannedItem);

    // Wait 1 second to show the success overlay, then navigate to the Details Screen
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      showSuccess = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(data: scannedItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Stack(
        children: [
          // QR Scanner
          MobileScanner(
            onDetect: (barcode, args) {
              final String? code = barcode.rawValue;
              if (code != null && code != scannedData) {
                _handleQRScanned(code);
              }
            },
          ),

          // Success Overlay
          if (showSuccess)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.all(40),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
