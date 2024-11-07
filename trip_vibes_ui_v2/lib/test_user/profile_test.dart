import 'package:flutter/material.dart';
import 'package:trip_vibes_ui_v2/test_user/edit_profile_screen_test.dart';
import 'package:trip_vibes_ui_v2/test_user/userModel.dart';
import 'package:trip_vibes_ui_v2/test_user/userService.dart';

class ProfileScreenTest extends StatefulWidget {
  final int userId;

  ProfileScreenTest({required this.userId});

  @override
  _ProfileScreenTestState createState() => _ProfileScreenTestState();
}

class _ProfileScreenTestState extends State<ProfileScreenTest> {
  late UserModel user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    UserService userService = UserService();
    try {
      UserModel fetchedUser = await userService.fetchUserProfile(widget.userId);
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      // Handle error (e.g., show a snackbar)
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${user.userName}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: user),
                        ),
                      ).then((value) => _fetchUser()); // Refresh on return
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
