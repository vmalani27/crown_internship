import 'package:flutter/material.dart';
import "package:training_app/pages/home_page.dart";
import 'package:training_app/pages/login_page.dart';


void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage()
    ),
  );
}