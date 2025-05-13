import 'package:flutter/material.dart';
import 'package:training_app_2/pages/text_cardview.dart';
import 'package:training_app_2/pages/photos_view.dart';
import 'package:training_app_2/pages/todo_cardview.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PhotosCardView()),
                );
              },
              child: const Text('Go to Photos View'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoCardView()),
                );
              },
              child: const Text('Go to Todo View'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextCardView()),
                );
              },
              child: const Text('Go to Text View'),
            ),
          ],
        ),
      ),
    );
  } 
}
