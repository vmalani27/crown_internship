import 'package:flutter/material.dart';
import 'package:training_app/api_helper/photos_view.dart';
import 'package:training_app/models/photos_view.dart';

class PhotosCardView extends StatefulWidget {
  const PhotosCardView({super.key});

  @override
  State<PhotosCardView> createState() => _PhotosCardViewState();
}

class _PhotosCardViewState extends State<PhotosCardView> {
  late Future<List<PhotosView>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = fetchPhotos(); // Fetch photos from the API
  }

  void _showDetailsDialog(BuildContext context, String url, String author) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Photo by $author'),
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
      appBar: AppBar(title: const Text('Photos View')),
      body: FutureBuilder<List<PhotosView>>(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No photos found'));
          } else {
            final List<PhotosView> photos = snapshot.data!;
            return ListView.builder(
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      photo.downloadUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                    title: Text(photo.author),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Photo ID: ${photo.id}'),
                        Text(
                          photo.url,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showDetailsDialog(
                        context,
                        photo.downloadUrl,
                        photo.author,
                      );
                    },
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
