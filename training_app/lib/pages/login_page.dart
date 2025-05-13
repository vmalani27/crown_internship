import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:training_app/api_helper/login_helper.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void _login(BuildContext scaffoldContext) async {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(content: Text('Username and Password cannot be empty')),
        );
        return;
      }

      // Call the login helper function
      final isSuccess = await login(username, password);

      if (isSuccess) {
        // Navigate to the HomePage if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Trial1()),
        );
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to the Login Page!'),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context), // Pass the correct context
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}