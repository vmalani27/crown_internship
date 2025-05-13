import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/model.dart';

final apiUrl = "https://glexas.com/hostel_data/API/test/new_admission_crud.php";

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData is Map<String, dynamic> && jsonData.containsKey('response')) {
      final List<dynamic> data = jsonData['response'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  } else {
    throw Exception('Failed to load users');
  }
}

Future<void> addUser(User user) async {
  final uri = Uri.parse(apiUrl);

  final payload = http.MultipartRequest('POST', uri)
    ..fields['user_code'] = user.userCode
    ..fields['first_name'] = user.firstName
    ..fields['middle_name'] = user.middleName
    ..fields['last_name'] = user.lastName
    ..fields['phone_number'] = user.phoneNumber
    ..fields['phone_country_code'] = user.phoneCountryCode
    ..fields['email'] = user.emailId;

  try {
    final streamedResponse = await payload.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('status') && jsonData['status'] == true) {
        return;
      } else {
        throw Exception('Unexpected API response format');
      }
    } else {
      throw Exception('Failed to add user: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error adding user: $e');
  }
}

Future<void> deleteUser(String registrationMainID) async {
  final uri = Uri.parse(apiUrl);
  final request = http.Request('DELETE', uri);
  request.headers.addAll({'Content-Type': 'application/json'});
  request.body = jsonEncode({'registration_main_id': registrationMainID});

  final response = await http.Client().send(request).then(http.Response.fromStream);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData is Map<String, dynamic> && jsonData.containsKey('message')) {
      return;
    } else {
      throw Exception('Unexpected API response format');
    }
  } else {
    throw Exception('Failed to delete user: ${response.statusCode}');
  }
}

Future<void> updateUser(User user) async {
  final uri = Uri.parse(apiUrl);

  final payload = http.MultipartRequest('POST', uri)
    ..fields['registration_main_id'] = user.registrationMainID
    ..fields['user_code'] = user.userCode
    ..fields['first_name'] = user.firstName
    ..fields['middle_name'] = user.middleName
    ..fields['last_name'] = user.lastName
    ..fields['phone_number'] = user.phoneNumber
    ..fields['phone_country_code'] = user.phoneCountryCode
    ..fields['email'] = user.emailId;

  try {
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('status') && jsonData['status'] == true) {
        return;
      } else {
        throw Exception('Unexpected API response format');
      }
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error updating user: $e');
  }
}