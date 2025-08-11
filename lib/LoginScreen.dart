import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tse/HomeScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF25A1F);

    // Use AnnotatedRegion to make the status bar transparent
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: orange, // This makes the status bar background orange
        statusBarIconBrightness: Brightness.light, // For light icons/text on the status bar
      ),
      child: Scaffold(
        backgroundColor: orange,
        body: SafeArea(
          child: Stack(
            children: [
              // Image at the top right, without any padding
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/login_logo.png',
                  height: 300, // Adjusted height for better layout
                ),
              ),

              // The login form is aligned to the bottom and centered
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Add a SizedBox to create space between the image and the form
                      const SizedBox(height: 60),
                      const Text(
                        'Sign in to proceed',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildInputField(Icons.email, 'Email'),
                      const SizedBox(height: 15),
                      _buildInputField(Icons.lock, 'Password', isPassword: true),
                      const SizedBox(height: 25),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: orange,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text(
                          'Log In',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Forgot password
                        },
                        child: const Text(
                          "Forgot Password? Click Here",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(height: 40,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}