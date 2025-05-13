import 'package:flutter/material.dart';
import 'home_page.dart';






class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text('Welcome to the Login Page!'),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the HomePage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Trial1()),
                  );
                },
                child: const Text('Go to Home Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}