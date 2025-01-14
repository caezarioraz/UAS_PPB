import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class UpdateUserScreen extends StatefulWidget {
  final int userId; // ID pengguna yang akan diperbarui

  UpdateUserScreen({required this.userId});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _userController = TextEditingController(); // Controller untuk nama pengguna
  final TextEditingController _usernameController = TextEditingController(); // Controller untuk username
  final TextEditingController _passwordController = TextEditingController(); // Controller untuk password
  String _role = 'customer'; // Default role

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data saat halaman ditampilkan
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userController.text = prefs.getString('user') ?? ''; // Ambil user
    _usernameController.text = prefs.getString('username') ?? ''; // Ambil username
    _passwordController.text = prefs.getString('password') ?? ''; // Ambil password
    _role = prefs.getString('role') ?? 'customer'; // Ambil role
  }

  Future<void> _updateUser() async {
    try {
      bool success = await _apiService.updateUser(
        widget.userId,
        _userController.text,
        _usernameController.text,
        _passwordController.text,
        _role, // Kirim role yang dipilih
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
        backgroundColor: Colors.blueAccent, // Dark blue theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.blueGrey[700],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.blueGrey[700],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.blueGrey[700],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // Dropdown untuk memilih role
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: _role,
                onChanged: (String? newValue) {
                  setState(() {
                    _role = newValue!;
                  });
                },
                dropdownColor: Colors.blueGrey[800],
                underline: Container(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                items: <String>['customer', 'admin']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Update User',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Dark background
    );
  }
}
