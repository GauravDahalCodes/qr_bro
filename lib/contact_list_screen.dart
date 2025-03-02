import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contact_detail_screen.dart'; // Ensure this import is correct
import 'dart:convert'; // For JSON decoding

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Map<String, dynamic>> _contacts = [];
  Set<int> _selectedIndices = {}; // Track selected contacts
  bool _isSelectionMode = false; // Track if selection mode is active

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList('contacts') ?? [];

    setState(() {
      _contacts = contactsJson.map((contact) {
        try {
          // Decode the JSON string and cast it to Map<String, dynamic>
          final decodedContact = jsonDecode(contact) as Map<String, dynamic>;
          return decodedContact;
        } catch (e) {
          // Handle invalid JSON or null values
          print('Error decoding contact: $e');
          return <String, dynamic>{}; // Return an empty map as a fallback
        }
      }).toList();
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) {
          _isSelectionMode =
              false; // Exit selection mode if no items are selected
        }
      } else {
        _selectedIndices.add(index);
        _isSelectionMode = true; // Enter selection mode
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedIndices.length == _contacts.length) {
        _selectedIndices.clear(); // Deselect all if all are selected
        _isSelectionMode = false;
      } else {
        _selectedIndices =
            Set<int>.from(Iterable.generate(_contacts.length, (i) => i));
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _deleteSelectedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedContacts = [];

    for (int i = 0; i < _contacts.length; i++) {
      if (!_selectedIndices.contains(i)) {
        updatedContacts
            .add(jsonEncode(_contacts[i])); // Keep non-selected contacts
      }
    }

    await prefs.setStringList('contacts', updatedContacts);

    setState(() {
      _contacts.removeWhere(
          (contact) => _selectedIndices.contains(_contacts.indexOf(contact)));
      _selectedIndices.clear();
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedIndices.length} Selected')
            : Text('Contacts'),
        actions: _isSelectionMode
            ? [
                IconButton(
                  icon: Icon(Icons.select_all),
                  onPressed: _selectAll,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteSelectedContacts,
                ),
              ]
            : null,
      ),
      body: _contacts.isEmpty
          ? Center(
              child: Text(
                'No contacts found. Scan a QR code to add contacts!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              itemCount: _contacts.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: contact['profilePhotoPath'] != null &&
                              contact['profilePhotoPath'].isNotEmpty
                          ? FileImage(File(contact['profilePhotoPath']))
                          : AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                    title: Text(
                      contact['name'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      contact['email'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: _isSelectionMode
                        ? Checkbox(
                            value: _selectedIndices.contains(index),
                            onChanged: (value) {
                              _toggleSelection(index);
                            },
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.message, color: Colors.blue),
                                onPressed: () {
                                  // Add messaging functionality
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.call, color: Colors.green),
                                onPressed: () {
                                  // Add calling functionality
                                },
                              ),
                            ],
                          ),
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSelection(index);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactDetailScreen(contact: contact),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      _toggleSelection(index);
                    },
                  ),
                );
              },
            ),
    );
  }
}
