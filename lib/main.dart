// Import necessary Flutter and Firebase packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import Firebase configuration file
import 'firebase_options.dart';

// Import internal app pages
import 'home_page.dart';
import 'login_page.dart';

void main() async {
  // Ensures Flutter binding is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase using platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Starts the Flutter application
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App', // Application title
      theme: ThemeData(primarySwatch: Colors.blue), // App theme color
      home: StreamBuilder<User?>(
        // Listens to authentication state changes
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Shows loading spinner while waiting for auth state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            // If user is logged in, go to HomePage
            return const HomePage();
          } else {
            // If no user is logged in, go to LoginPage
            return const LoginPage();
          }
        },
      ),
    );
  }
}
