import 'package:breeze_mobile/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:breeze_mobile/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserDetails() async {
    User? currentUser = AuthService().getCurrentUser();
    if (currentUser != null) {
      UserModel? user = await AuthService().getUserDetails(currentUser.uid);
      if (user != null) {
        setState(() {
          _user = user;
          _usernameController.text = user.username;
        });
      }
    }
  }

  void _changePassword() async {
    try {
      await AuthService().changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to change password: $e")),
      );
    }
  }

  void _updateUsername() async {
    if (_user != null) {
      try {
        await AuthService()
            .updateUsername(_user!.uid, _usernameController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username updated successfully")),
        );
        setState(() {
          _user!.username = _usernameController.text;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update username: $e")),
        );
      }
    }
  }

  void _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete Account"),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await AuthService().deleteUserAccount();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Account deleted successfully")),
                  );
                  Navigator.of(context).pushReplacementNamed('/login');
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to delete account: $e")),
                  );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Color.fromRGBO(255, 166, 0, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${_user!.email}'),
                  const SizedBox(height: 8),
                  Text('UID: ${_user!.uid}'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUsername,
                    child: const Text('Update Username'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _oldPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Old Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text('Change Password'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
      ),
    );
  }
}
