import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrbro/contact_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// Correct import

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanning = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanning) {
      setState(() {
        _isScanning = false; // Prevent multiple scans
      });

      final List<Barcode> barcodes = capture.barcodes;
      for (final barcode in barcodes) {
        final String? qrData = barcode.rawValue;
        if (qrData != null) {
          // Save the scanned data as a contact
          _saveContact(qrData);

          // Navigate back to the contact list screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ContactListScreen(),
            ),
          );
        }
      }
    }
  }

  Future<void> _saveContact(String qrData) async {
    try {
      // Decode the JSON-encoded QR data
      final Map<String, dynamic> profileData = jsonDecode(qrData);

      // Save the contact to shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final contacts = prefs.getStringList('contacts') ?? [];
      contacts.add(qrData); // Save the raw JSON data for simplicity
      await prefs.setStringList('contacts', contacts);
    } catch (e) {
      print('Error decoding QR data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect, // Handle scanned QR codes
                ),
                // Custom overlay for scanning effect
                _buildScannerOverlay(context),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan a QR code to add a contact',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom overlay for scanning effect
  Widget _buildScannerOverlay(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: _ScannerOverlayPainter(_animationController.value),
        );
      },
    );
  }
}

// Custom painter for the scanning effect
class _ScannerOverlayPainter extends CustomPainter {
  final double animationValue;

  _ScannerOverlayPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw a rectangle border
    final rect = Rect.fromLTWH(
      size.width * 0.1, // 10% padding from the left
      size.height * 0.2, // 20% padding from the top
      size.width * 0.8, // 80% width
      size.height * 0.6, // 60% height
    );
    canvas.drawRect(rect, paint);

    // Draw a moving line for scanning effect
    final linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    final lineOffset = Offset(
      0,
      rect.top + (rect.height * animationValue),
    );
    canvas.drawLine(
      Offset(rect.left, lineOffset.dy),
      Offset(rect.right, lineOffset.dy),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
