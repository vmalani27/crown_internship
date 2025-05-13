import 'package:flutter/material.dart';
import 'package:training_app_2/api/photos_view.dart';
import 'package:training_app_2/models/photos_view.dart';

class PhotosCardView extends StatefulWidget {
  const PhotosCardView({super.key});

  @override
  State<PhotosCardView> createState() => _PhotosCardViewState();
}

class _PhotosCardViewState extends State<PhotosCardView> {
  late Future<List<dynamic>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  void _showDetailsDialog(BuildContext context, String url, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
                final Photoview = PhotosView.fromJson(post);
                final thumbnailUrl = Photoview.thumbnailUrl ?? '';
                final url = Photoview.url ?? '';
                final title = Photoview.title ?? 'No Title';
                final id = Photoview.id;
                return Card(
                  child: ExpansionTile(
                    title: Text(title),
                    subtitle: Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {}
                    },
                    children: [
                      TextButton(
                        onPressed: () => _showDetailsDialog(context, url, title),
                        child: const Text('View Details'),
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