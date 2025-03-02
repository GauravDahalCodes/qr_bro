import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final Function(bool) onEditModeChanged;

  ProfileScreen({required this.onEditModeChanged});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  File? _profilePhoto;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _moviesController = TextEditingController();
  final TextEditingController _musicController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _personalityController = TextEditingController();
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _happinessController = TextEditingController();
  final TextEditingController _weekendController = TextEditingController();
  final TextEditingController _travelController = TextEditingController();
  final TextEditingController _talentController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();
  final TextEditingController _superpowerController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _dobController.text = prefs.getString('dob') ?? '';
      _genderController.text = prefs.getString('gender') ?? '';
      _hobbiesController.text = prefs.getString('hobbies') ?? '';
      _moviesController.text = prefs.getString('movies') ?? '';
      _musicController.text = prefs.getString('music') ?? '';
      _foodController.text = prefs.getString('food') ?? '';
      _personalityController.text = prefs.getString('personality') ?? '';
      _quoteController.text = prefs.getString('quote') ?? '';
      _happinessController.text = prefs.getString('happiness') ?? '';
      _weekendController.text = prefs.getString('weekend') ?? '';
      _travelController.text = prefs.getString('travel') ?? '';
      _talentController.text = prefs.getString('talent') ?? '';
      _emojiController.text = prefs.getString('emoji') ?? '';
      _superpowerController.text = prefs.getString('superpower') ?? '';
      _instagramController.text = prefs.getString('instagram') ?? '';
      _facebookController.text = prefs.getString('facebook') ?? '';
      _twitterController.text = prefs.getString('twitter') ?? '';
      _tiktokController.text = prefs.getString('tiktok') ?? '';
      _profilePhoto = prefs.getString('profilePhotoPath') != null
          ? File(prefs.getString('profilePhotoPath')!)
          : null;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', _nameController.text);
      prefs.setString('phone', _phoneController.text);
      prefs.setString('email', _emailController.text);
      prefs.setString('dob', _dobController.text);
      prefs.setString('gender', _genderController.text);
      prefs.setString('hobbies', _hobbiesController.text);
      prefs.setString('movies', _moviesController.text);
      prefs.setString('music', _musicController.text);
      prefs.setString('food', _foodController.text);
      prefs.setString('personality', _personalityController.text);
      prefs.setString('quote', _quoteController.text);
      prefs.setString('happiness', _happinessController.text);
      prefs.setString('weekend', _weekendController.text);
      prefs.setString('travel', _travelController.text);
      prefs.setString('talent', _talentController.text);
      prefs.setString('emoji', _emojiController.text);
      prefs.setString('superpower', _superpowerController.text);
      prefs.setString('instagram', _instagramController.text);
      prefs.setString('facebook', _facebookController.text);
      prefs.setString('twitter', _twitterController.text);
      prefs.setString('tiktok', _tiktokController.text);

      if (_profilePhoto != null) {
        prefs.setString('profilePhotoPath', _profilePhoto!.path);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully!')),
      );

      setState(() {
        _isEditing = false;
      });

      widget.onEditModeChanged(false);
    }
  }

  void _toggleEditMode(bool isEditing) {
    setState(() {
      _isEditing = isEditing;
    });
    widget.onEditModeChanged(isEditing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        leading: _isEditing
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _toggleEditMode(false);
                },
              )
            : null,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _toggleEditMode(true);
              },
            ),
        ],
      ),
      body: _isEditing ? _buildEditProfilePage() : _buildProfilePage(),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: _saveProfile,
              child: Icon(Icons.save),
            )
          : null,
    );
  }

  Widget _buildProfilePage() {
    final List<Map<String, dynamic>> filledDetails = [
      if (_nameController.text.isNotEmpty)
        {'label': 'Name', 'value': _nameController.text, 'icon': Icons.person},
      if (_phoneController.text.isNotEmpty)
        {'label': 'Phone', 'value': _phoneController.text, 'icon': Icons.phone},
      if (_emailController.text.isNotEmpty)
        {'label': 'Email', 'value': _emailController.text, 'icon': Icons.email},
      if (_dobController.text.isNotEmpty)
        {'label': 'Birthday', 'value': _dobController.text, 'icon': Icons.cake},
      if (_genderController.text.isNotEmpty)
        {
          'label': 'Gender',
          'value': _genderController.text,
          'icon': Icons.transgender
        },
      if (_hobbiesController.text.isNotEmpty)
        {
          'label': 'Hobbies',
          'value': _hobbiesController.text,
          'icon': Icons.sports
        },
      if (_moviesController.text.isNotEmpty)
        {
          'label': 'Favorite Movies/TV Shows',
          'value': _moviesController.text,
          'icon': Icons.movie
        },
      if (_musicController.text.isNotEmpty)
        {
          'label': 'Favorite Music/Artists',
          'value': _musicController.text,
          'icon': Icons.music_note
        },
      if (_foodController.text.isNotEmpty)
        {
          'label': 'Favorite Food',
          'value': _foodController.text,
          'icon': Icons.fastfood
        },
      if (_personalityController.text.isNotEmpty)
        {
          'label': 'Personality',
          'value': _personalityController.text,
          'icon': Icons.psychology
        },
      if (_quoteController.text.isNotEmpty)
        {
          'label': 'Favorite Quote',
          'value': _quoteController.text,
          'icon': Icons.format_quote
        },
      if (_happinessController.text.isNotEmpty)
        {
          'label': 'Things That Make Me Happy',
          'value': _happinessController.text,
          'icon': Icons.emoji_emotions
        },
      if (_weekendController.text.isNotEmpty)
        {
          'label': 'Ideal Weekend Plan',
          'value': _weekendController.text,
          'icon': Icons.weekend
        },
      if (_travelController.text.isNotEmpty)
        {
          'label': 'Dream Travel Destination',
          'value': _travelController.text,
          'icon': Icons.flight
        },
      if (_talentController.text.isNotEmpty)
        {
          'label': 'Hidden Talent',
          'value': _talentController.text,
          'icon': Icons.star
        },
      if (_emojiController.text.isNotEmpty)
        {
          'label': 'Favorite Emoji',
          'value': _emojiController.text,
          'icon': Icons.emoji_emotions
        },
      if (_superpowerController.text.isNotEmpty)
        {
          'label': 'If I Had a Superpower',
          'value': _superpowerController.text,
          'icon': Icons.flash_on
        },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _profilePhoto != null
                  ? FileImage(_profilePhoto!)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 4,
              children: [
                if (_instagramController.text.isNotEmpty)
                  _buildSocialMediaIconButton(
                    icon: FontAwesomeIcons.instagram,
                    onPressed: () => _launchURL('${_instagramController.text}'),
                  ),
                if (_facebookController.text.isNotEmpty)
                  _buildSocialMediaIconButton(
                    icon: FontAwesomeIcons.facebook,
                    onPressed: () => _launchURL('${_facebookController.text}'),
                  ),
                if (_twitterController.text.isNotEmpty)
                  _buildSocialMediaIconButton(
                    icon: FontAwesomeIcons.twitter,
                    onPressed: () => _launchURL('${_twitterController.text}'),
                  ),
                if (_tiktokController.text.isNotEmpty)
                  _buildSocialMediaIconButton(
                    icon: FontAwesomeIcons.tiktok,
                    onPressed: () => _launchURL('${_tiktokController.text}'),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ...filledDetails.map((detail) => _buildDetailCard(detail)).toList(),
        ],
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
        padding: const EdgeInsets.all(20.0),
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    detail['value'],
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profilePhoto != null
                        ? FileImage(_profilePhoto!)
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF15A157),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'General Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildEditProfileField('Name', _nameController),
            _buildEditProfileField('Phone', _phoneController),
            _buildEditProfileField('Email', _emailController),
            _buildDatePickerField('Birthday', _dobController),
            _buildGenderDropdown('Gender', _genderController),
            SizedBox(height: 20),
            Text(
              'Interests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildEditProfileField('Hobbies', _hobbiesController),
            _buildEditProfileField(
                'Favorite Movies/TV Shows', _moviesController),
            _buildEditProfileField('Favorite Music/Artists', _musicController),
            _buildEditProfileField('Favorite Food', _foodController),
            _buildEditProfileField('Personality', _personalityController),
            _buildEditProfileField('Favorite Quote', _quoteController),
            _buildEditProfileField(
                'Things That Make Me Happy', _happinessController),
            _buildEditProfileField('Ideal Weekend Plan', _weekendController),
            _buildEditProfileField(
                'Dream Travel Destination', _travelController),
            _buildEditProfileField('Hidden Talent', _talentController),
            _buildEditProfileField('Favorite Emoji', _emojiController),
            _buildEditProfileField(
                'If I Had a Superpower', _superpowerController),
            SizedBox(height: 20),
            Text(
              'Social Media',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildEditSocialMediaField(
                'Instagram', _instagramController, FontAwesomeIcons.instagram),
            _buildEditSocialMediaField(
                'Facebook', _facebookController, FontAwesomeIcons.facebook),
            _buildEditSocialMediaField(
                'Twitter (X)', _twitterController, FontAwesomeIcons.twitter),
            _buildEditSocialMediaField(
                'TikTok', _tiktokController, FontAwesomeIcons.tiktok),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIconButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, size: 32, color: Color(0xFF15A157)),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
    );
  }

  Widget _buildEditProfileField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            _calculateAge(pickedDate);
          }
        },
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ),
    );
  }

  void _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    _ageController.text = age.toString();
  }

  Widget _buildGenderDropdown(String label, TextEditingController controller) {
    final List<String> genders = ['Male', 'Female', 'Other'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: genders.contains(controller.text) ? controller.text : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        items: genders.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.text = newValue!;
        },
      ),
    );
  }

  Widget _buildEditSocialMediaField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not call $phoneNumber')),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not email $email')),
      );
    }
  }
}
