import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_vibes_ui_v2/screens/pages/user_screen/edit_profile_screen.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String userEmail;

  const ProfileScreen(
      {Key? key,
      required this.userId,
      required this.userEmail,
      required this.userName})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';
  String? profileImagePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    final userData = await AuthService().getUserData(widget.userId);
    if (userData != null) {
      setState(() {
        userName = userData['user_name'];
        userEmail = userData['email'];
        profileImagePath = userData['profile_picture'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  const Color(0xff5100F2).withOpacity(0.8),
                              backgroundImage: profileImagePath != null
                                  ? NetworkImage(
                                      'http://192.168.44.1:4000/api/public/images/users/$profileImagePath')
                                  : const AssetImage('assets/images/panda.jpg')
                                      as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 8,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              child: Icon(Icons.camera_alt,
                                  size: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      readOnly: true,
                      initialValue: userName,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      initialValue: userEmail,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(userId: widget.userId),
                            ),
                          );
                          if (result == true) {
                            _fetchUserData(); // Reload user data after update
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Update Profile',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/trip');
          },
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.home, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
