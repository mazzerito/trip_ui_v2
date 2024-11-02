import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    //borderSide: BorderSide(color: Colors.grey),
                    
                  ),
                  
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey,),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
        
              // Password Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your Password',
                  //filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility
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
              const SizedBox(height: 20),
        
              // Login Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/trip');
                  },
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
    );
  }
}
