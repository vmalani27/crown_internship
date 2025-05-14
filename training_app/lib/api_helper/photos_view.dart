import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:training_app/models/photos_view.dart';

final url = "https://jsonplaceholder.typicode.com/photos";

Future<List<dynamic>> fetchPosts() async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> posts = json.decode(response.body);
    print(posts.length);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load posts');
  }
}
