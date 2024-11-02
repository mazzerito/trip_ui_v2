import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", 
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
        
              // Profile Picture with Camera Icon
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xff5100F2).withOpacity(0.8),
                      child: const CircleAvatar(
                        radius: 58,
                        backgroundImage: AssetImage('assets/images/panda.jpg'), 
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 8,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                          )
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
        
              // Full Name Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  //hintText: 'Pao Peters',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
        
              // Email Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  //hintText: 'pao@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
        
              // Password Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  //hintText: '**********',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                ),
                obscureText: _isPasswordHidden,
                ),
              const SizedBox(height: 32),
        
              // Update Profile Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle profile update
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5100F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 16),
        
              // Logout Button
              
            ],
          ),
        ),
      ),
    );
  }
}
