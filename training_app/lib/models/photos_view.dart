//"albumId": 1,
//         "id": 1,
//         "title": "accusamus beatae ad facilis cum similique qui sunt",
//         "url": "https://via.placeholder.com/600/92c952",
//         "thumbnailUrl": "https://via.placeholder.com/150/92c952"

import 'package:flutter/foundation.dart';

class PhotosView {
  final String albumId;
  final String url;
  final String id;
  final String title;
  final String thumbnailUrl;


  PhotosView({
    required this.url,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.albumId,
  });

  factory PhotosView.fromJson(Map<String, dynamic> json) {
    return PhotosView(
      url: json['url'].toString(),
      id: json['id'].toString(),
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      albumId: json['albumId'].toString(),
    );
  }
}