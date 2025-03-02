import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailScreen extends StatelessWidget {
  final Map<String, dynamic> contact;

  ContactDetailScreen({required this.contact});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filledDetails = [
      if (contact['name'] != null && contact['name'].isNotEmpty)
        {'label': 'Name', 'value': contact['name'], 'icon': Icons.person},
      if (contact['phone'] != null && contact['phone'].isNotEmpty)
        {'label': 'Phone', 'value': contact['phone'], 'icon': Icons.phone},
      if (contact['email'] != null && contact['email'].isNotEmpty)
        {'label': 'Email', 'value': contact['email'], 'icon': Icons.email},
      if (contact['age'] != null && contact['age'].isNotEmpty)
        {'label': 'Age', 'value': contact['age'], 'icon': Icons.cake},
      if (contact['dob'] != null && contact['dob'].isNotEmpty)
        {
          'label': 'Birthday',
          'value': contact['dob'],
          'icon': Icons.calendar_today
        },
      if (contact['gender'] != null && contact['gender'].isNotEmpty)
        {
          'label': 'Gender',
          'value': contact['gender'],
          'icon': Icons.transgender
        },
      if (contact['hobbies'] != null && contact['hobbies'].isNotEmpty)
        {'label': 'Hobbies', 'value': contact['hobbies'], 'icon': Icons.sports},
      if (contact['movies'] != null && contact['movies'].isNotEmpty)
        {
          'label': 'Favorite Movies/TV Shows',
          'value': contact['movies'],
          'icon': Icons.movie
        },
      if (contact['music'] != null && contact['music'].isNotEmpty)
        {
          'label': 'Favorite Music/Artists',
          'value': contact['music'],
          'icon': Icons.music_note
        },
      if (contact['food'] != null && contact['food'].isNotEmpty)
        {
          'label': 'Favorite Food',
          'value': contact['food'],
          'icon': Icons.fastfood
        },
      if (contact['personality'] != null && contact['personality'].isNotEmpty)
        {
          'label': 'Personality',
          'value': contact['personality'],
          'icon': Icons.psychology
        },
      if (contact['quote'] != null && contact['quote'].isNotEmpty)
        {
          'label': 'Favorite Quote',
          'value': contact['quote'],
          'icon': Icons.format_quote
        },
      if (contact['happiness'] != null && contact['happiness'].isNotEmpty)
        {
          'label': 'Things That Make Me Happy',
          'value': contact['happiness'],
          'icon': Icons.emoji_emotions
        },
      if (contact['weekend'] != null && contact['weekend'].isNotEmpty)
        {
          'label': 'Ideal Weekend Plan',
          'value': contact['weekend'],
          'icon': Icons.weekend
        },
      if (contact['travel'] != null && contact['travel'].isNotEmpty)
        {
          'label': 'Dream Travel Destination',
          'value': contact['travel'],
          'icon': Icons.flight
        },
      if (contact['talent'] != null && contact['talent'].isNotEmpty)
        {
          'label': 'Hidden Talent',
          'value': contact['talent'],
          'icon': Icons.star
        },
      if (contact['emoji'] != null && contact['emoji'].isNotEmpty)
        {
          'label': 'Favorite Emoji',
          'value': contact['emoji'],
          'icon': Icons.emoji_emotions
        },
      if (contact['superpower'] != null && contact['superpower'].isNotEmpty)
        {
          'label': 'If I Had a Superpower',
          'value': contact['superpower'],
          'icon': Icons.flash_on
        },
    ];

    final List<Map<String, dynamic>> socialMedia = [
      if (contact['instagram'] != null && contact['instagram'].isNotEmpty)
        {
          'platform': 'Instagram',
          'handle': contact['instagram'],
          'icon': FontAwesomeIcons.instagram
        },
      if (contact['facebook'] != null && contact['facebook'].isNotEmpty)
        {
          'platform': 'Facebook',
          'handle': contact['facebook'],
          'icon': FontAwesomeIcons.facebook
        },
      if (contact['twitter'] != null && contact['twitter'].isNotEmpty)
        {
          'platform': 'Twitter (X)',
          'handle': contact['twitter'],
          'icon': FontAwesomeIcons.twitter
        },
      if (contact['tiktok'] != null && contact['tiktok'].isNotEmpty)
        {
          'platform': 'TikTok',
          'handle': contact['tiktok'],
          'icon': FontAwesomeIcons.tiktok
        },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF15A157), Color(0xFF0D6EFD)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80), // Add space at the top
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: contact['profilePhotoPath'] != null &&
                          contact['profilePhotoPath'].isNotEmpty
                      ? FileImage(File(contact['profilePhotoPath']))
                      : AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
              ),
              SizedBox(height: 20), // Space between photo and social media
              if (socialMedia.isNotEmpty)
                Center(
                  child: Wrap(
                    spacing: 16, // Space between social media icons
                    children: socialMedia
                        .map((platform) => _buildSocialMediaIconButton(
                              icon: platform['icon'],
                              onPressed: () => _launchURL(
                                  'https://${platform['platform'].toLowerCase()}.com/${platform['handle']}'),
                            ))
                        .toList(),
                  ),
                ),
              SizedBox(height: 20), // Space between social media and details
              if (filledDetails.isNotEmpty)
                Text(
                  'General Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              SizedBox(height: 10),
              ...filledDetails
                  .map((detail) => _buildDetailCard(detail))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> detail) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(detail['icon'], size: 30, color: Color(0xFF15A157)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail['label'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    detail['value'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (detail['label'] == 'Phone' || detail['label'] == 'Email')
              IconButton(
                icon: Icon(
                  detail['label'] == 'Phone' ? Icons.phone : Icons.email,
                  color: Color(0xFF15A157),
                ),
                onPressed: () {
                  if (detail['label'] == 'Phone') {
                    _makePhoneCall(detail['value']);
                  } else if (detail['label'] == 'Email') {
                    _sendEmail(detail['value']);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 32, color: Colors.white),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not email $email';
    }
  }
}
