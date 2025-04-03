// Import Flutter Material components
import 'package:flutter/material.dart';
// Import Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';

// LoginPage is a StatefulWidget to manage login and register form
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State class for LoginPage
class _LoginPageState extends State<LoginPage> {
  // Controller to handle email input
  final _emailController = TextEditingController();
  // Controller to handle password input
  final _passwordController = TextEditingController();

  // Flag to determine if the user is in login mode or register mode
  bool _isLogin = true;
  // Variable to hold error messages
  String? _error;

  // Method to handle authentication logic (login or register)
  Future<void> _handleAuth() async {
    try {
      if (_isLogin) {
        // Attempt to sign in with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Attempt to create a new user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } catch (e) {
      // If error occurs, update the error variable
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar shows either 'Login' or 'Register' based on current mode
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Display error message if any
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            // Password input field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, // Hide password characters
            ),

            const SizedBox(height: 20),

            // Submit button (Login or Register)
            ElevatedButton(
              onPressed: _handleAuth,
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),

            // Button to toggle between login and register modes
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin; // Switch mode
                  _error = null; // Clear error
                });
              },
              child: Text(
                _isLogin
                    ? "Don't have an account? Register"
                    : "Already have an account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
