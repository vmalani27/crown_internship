import 'package:flutter/material.dart';
import 'package:training_app_2/api/text_body.dart';
import 'package:training_app_2/models/text_body.dart';

class TextCardView extends StatefulWidget {
  const TextCardView({super.key});

  @override
  State<TextCardView> createState() => _TextCardViewState();
}

class _TextCardViewState extends State<TextCardView> {
  late Future<List<dynamic>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Card View'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final List<dynamic> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final text = TextBody.fromJson(post);
                final userId = text.userId;
                final id = text.id;
                return Card(
                  child: ExpansionTile(
                  title: Text('User ID: $userId'),
                  subtitle: Text('ID: $id'),
                  children: [
                    Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Title: ${text.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Body: ${text.body}'),
                      ],
                    ),
                    ),
                  ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}