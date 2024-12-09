import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String address;

  EditProfileScreen({
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _roleController = TextEditingController(text: widget.role);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'role': _roleController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: _saveProfile,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Full Name', _nameController),
            _buildTextField('Role', _roleController),
            _buildTextField('Email', _emailController),
            _buildTextField('Phone', _phoneController),
            _buildTextField('Address', _addressController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
