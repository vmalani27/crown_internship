import 'package:flutter/foundation.dart';

class PhotosView {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  PhotosView({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory PhotosView.fromJson(Map<String, dynamic> json) {
    return PhotosView(
      id: json['id'].toString(),
      author: json['author'],
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'],
      downloadUrl: json['download_url'],
    );
  }
}
