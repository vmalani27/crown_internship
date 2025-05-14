import 'package:flutter/material.dart';
import 'package:training_app/api_helper/photos_view.dart';
import 'package:training_app/models/photos_view.dart';

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
    try {
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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error displaying details: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Card View')),
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
                try {
                  final post = posts[index];
                  final photoview = PhotosView.fromJson(post);
                  final thumbnailUrl = photoview.thumbnailUrl ?? '';
                  final url = photoview.url ?? '';
                  final title = photoview.title ?? 'No Title';

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
                        try {
                          if (isExpanded) {}
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error expanding card: $e')),
                          );
                        }
                      },
                      children: [
                        TextButton(
                          onPressed: () {
                            try {
                              _showDetailsDialog(context, url, title);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error opening dialog: $e'),
                                ),
                              );
                            }
                          },
                          child: const Text('View Details'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  return ListTile(
                    title: const Text('Error loading post'),
                    subtitle: Text(e.toString()),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
