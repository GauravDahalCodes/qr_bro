import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'qr_generator_screen.dart';
import 'qr_scanner_screen.dart';
import 'contact_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ValueNotifier<bool> _isEditingNotifier = ValueNotifier<bool>(false);

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ProfileScreen(
        onEditModeChanged: (isEditing) {
          _isEditingNotifier.value = isEditing;
        },
      ),
      QRGeneratorScreen(),
      QRScannerScreen(),
      ContactListScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _isEditingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isEditingNotifier,
      builder: (context, isEditing, child) {
        return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: isEditing
              ? null
              : BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Color(0xFF00BF5B),
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  iconSize: 28,
                  selectedFontSize: 14,
                  unselectedFontSize: 12,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.person),
                      ),
                      label: 'Profile',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.qr_code),
                      ),
                      label: 'QR Generator',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.camera_alt),
                      ),
                      label: 'QR Scanner',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.contacts),
                      ),
                      label: 'Contacts',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
