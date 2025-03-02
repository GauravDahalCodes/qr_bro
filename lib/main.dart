import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'qr_generator_screen.dart';
import 'qr_scanner_screen.dart';
import 'contact_list_screen.dart';
import 'contact_detail_screen.dart';

void main() {
  runApp(QRBroApp());
}

class QRBroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRBro',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(
              onEditModeChanged: (isEditing) {},
            ),
        '/qrGenerator': (context) => QRGeneratorScreen(),
        '/qrScanner': (context) => QRScannerScreen(),
        '/contactList': (context) => ContactListScreen(),
        '/contactDetail': (context) {
          final contact = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ContactDetailScreen(contact: contact);
        },
      },
    );
  }
}
