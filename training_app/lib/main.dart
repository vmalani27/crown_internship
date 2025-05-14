import 'package:flutter/material.dart';
import 'package:training_app/pages/home_page.dart';
import 'package:training_app/pages/login_page.dart';
import 'package:training_app/pages/todo_cardview.dart';
import 'package:training_app/pages/photos_view.dart';
import 'package:training_app/pages/text_cardview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
