import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../services/authService.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;
  final AuthService _apiService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final loginData = {
          'email': _emailController.text,
          'password': _passwordController.text,
        };

        final response = await _apiService.login(loginData);

        if (response['statusCode'] == 200) {
          final result = response['body'];
          dynamic dataUser = result;
          print(">> result = " + dataUser["user"]["user_name"] + " >>> user_id = " + dataUser["user"]["email"].toString());
          
          keepCookieUser(
            dataUser["user"]["user_name"], 
            dataUser["user"]["email"], 
            dataUser["user"]["user_id"]
          );
          
          getCookieUser();
          Navigator.pushNamedAndRemoveUntil(context, '/splash', (route) => false,
              arguments: result);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Login failed: ${response['body']['message'] ?? 'Unknown error'}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  keepCookieUser(String name, String email, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name',name);
    prefs.setString('email',email);
    prefs.setInt('userId',userId);
  }

  getCookieUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return bool
      String user_name = prefs.getString('name') ?? "null=value";
      String user_email = prefs.getString('user_email') ?? "null=value";
      int user_id = prefs.getInt("userId")?? 0;
      print('>>> user_name' + user_name);
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
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    //color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Email Address Field
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Your Password',
                      //filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility),
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
                    }),
                const SizedBox(height: 20),

                // Login Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          // onPressed: () {
                          //   //Navigator.of(context).pushNamed('/trip');
                          //   _isLoading ? null : _login;
                          // },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff5100F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
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
                        "Don't have an account yet? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: const Text(
                          'SignUp',
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
