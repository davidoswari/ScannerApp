import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final Function(String, String) onProfileUpdated;

  ProfileScreen({
    required this.userName,
    required this.userRole,
    required this.onProfileUpdated,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String role;
  String email = 'john.doe@example.com';
  String phone = '+1 234 567 890';
  String address = '123 Main St, Cityville';

  @override
  void initState() {
    super.initState();
    name = widget.userName;
    role = widget.userRole;
  }

  void _editProfile() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          name: name,
          role: role,
          email: email,
          phone: phone,
          address: address,
        ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        name = updatedData['name'];
        role = updatedData['role'];
        email = updatedData['email'];
        phone = updatedData['phone'];
        address = updatedData['address'];
      });

      // Update the profile in the parent widget
      widget.onProfileUpdated(name, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade100,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16),
          Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(role, style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
          Divider(height: 32, thickness: 1),
          _buildInfoRow(Icons.email, 'Email', email),
          _buildInfoRow(Icons.phone, 'Phone', phone),
          _buildInfoRow(Icons.location_on, 'Address', address),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _editProfile,
            icon: Icon(Icons.edit),
            label: Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
