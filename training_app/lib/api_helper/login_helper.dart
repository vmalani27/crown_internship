import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/model.dart';

final apiUrl = "https://glexas.com/hostel_data/API/test/login.php";


Future<bool> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == true;
    } else {
      return false;
    }
  } catch (e) {
    ;
    print("Error: $e");
    return false;
  }
}

