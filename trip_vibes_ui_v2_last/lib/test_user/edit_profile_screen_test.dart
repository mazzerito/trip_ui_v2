import 'package:flutter/material.dart';
import 'userModel.dart';
import 'userService.dart';


class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.user.userName);
    emailController = TextEditingController(text: widget.user.email);
    passwordController = TextEditingController();
  }

  Future<void> _updateProfile() async {
    UserService userService = UserService();
    widget.user.userName = userNameController.text;
    widget.user.email = emailController.text;
    widget.user.password = passwordController.text.isNotEmpty ? passwordController.text : null;

    try {
      await userService.updateUserProfile(widget.user);
      Navigator.pop(context, true); // Return to profile screen and refresh
    } catch (e) {
      // Handle error (e.g., show a snackbar)
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
