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
      home: const TabView(),
    );
  }
}

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tab View Example'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Users'),
              Tab(icon: Icon(Icons.task), text: 'todo'),
              Tab(icon: Icon(Icons.photo), text: 'photos'),
              Tab(icon: Icon(Icons.text_decrease), text: 'text'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomePage(),
            TodoCardView(),
            PhotosCardView(),
            TextCardView(),
          ],
        ),
      ),
    );
  }
}
