import 'package:flutter/material.dart';

import '../../../services/authService.dart';


class SignupScreen extends StatefulWidget {
  //const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordHidden = true;
    final AuthService authService = AuthService();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool _isLoading = false; // Loading state for the button
    final _formKey = GlobalKey<FormState>();
    
      void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final signupData = {
        'user_name': userNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      };

      try {
        final response = await authService.signup(signupData);

        if (response['statusCode'] == 201) {
          Navigator.pushNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('signup failed: ${response['body']['message'] ?? 'Unknown error'}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('signup failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo at the top
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Image.asset(
                          'assets/images/logo.png',
                           // Replace with your logo asset path
                          height: 200,
                        ),
                      ),
                    ], 
                  ),
                ),
                const SizedBox(height: 5),
                    
                // Login Heading
                const Text(
                  "SignUp",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                    
                // Email Address Field
                TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey,),
                  ),
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your user name';
                      }
                      return null;
                    },
                ),
                const SizedBox(height: 16),
            
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey,),
                  ),
                  
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                ),

                const SizedBox(height: 16),
                    
                // Password Field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Your Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
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
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                ),
                const SizedBox(height: 20),
                    
                // Login Button
                _isLoading
                      ? const CircularProgressIndicator()
                      :SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : registerUser,
                            // onPressed: () {
                            //   _isLoading ? null : registerUser;
                            //   //Navigator.of(context).pushNamed('/trip');
                            // },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff5100F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'SignUp',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                const SizedBox(height: 16),
                    
                // Signup Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xffFF914D),
                            fontWeight: FontWeight.bold,
                            //decoration: TextDecoration.underline,
                            //decorationColor: Color(0xffFF914D),
                            //decorationThickness: 2
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
