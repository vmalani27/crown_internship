import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:training_app/models/photos_view.dart';

final url = "https://picsum.photos/v2/list";

Future<List<PhotosView>> fetchPhotos() async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    // Map the JSON data to a list of PhotosView objects
    return jsonData.map((json) => PhotosView.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load photos');
  }
}
