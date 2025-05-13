import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/model.dart';

final apiUrl = "https://glexas.com/hostel_data/API/test/login.php";


Future<bool> login(String username, String password) async {
  try {
    final uri = Uri.parse(apiUrl);
    final payload = http.MultipartRequest('POST', uri)
      ..fields['username'] = username
      ..fields['password'] = password;
      try{
        final streamedResponse = await payload.send();
        final response = await http.Response.fromStream(streamedResponse);

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
  } catch (e) {
    print("Error: $e");
    return false;
  }}