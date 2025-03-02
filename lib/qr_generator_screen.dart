import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding

class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = {
      'name': prefs.getString('name') ?? '',
      'phone': prefs.getString('phone') ?? '', // Add phone
      'email': prefs.getString('email') ?? '', // Add email
      'age': prefs.getString('age') ?? '',
      'dob': prefs.getString('dob') ?? '',
      'gender': prefs.getString('gender') ?? '',
      'hobbies': prefs.getString('hobbies') ?? '',
      'movies': prefs.getString('movies') ?? '',
      'music': prefs.getString('music') ?? '',
      'food': prefs.getString('food') ?? '',
      'personality': prefs.getString('personality') ?? '',
      'quote': prefs.getString('quote') ?? '',
      'happiness': prefs.getString('happiness') ?? '',
      'weekend': prefs.getString('weekend') ?? '',
      'travel': prefs.getString('travel') ?? '',
      'talent': prefs.getString('talent') ?? '',
      'emoji': prefs.getString('emoji') ?? '',
      'superpower': prefs.getString('superpower') ?? '',
      'instagram': prefs.getString('instagram') ?? '',
      'facebook': prefs.getString('facebook') ?? '',
      'twitter': prefs.getString('twitter') ?? '',
      'tiktok': prefs.getString('tiktok') ?? '',
      'profilePhotoPath': prefs.getString('profilePhotoPath') ?? '',
    };

    setState(() {
      _qrData = jsonEncode(profileData); // Convert profile data to JSON
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_qrData.isNotEmpty)
              QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: 200.0,
              ),
            SizedBox(height: 20),
            Text(
              'Scan this QR code to share your profile!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
