import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:training_app/model.dart';
import 'cardview.dart';

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

  // Prepare the form data payload
  final payload = http.MultipartRequest('POST', uri)
    ..fields['user_code'] = user.userCode
    ..fields['first_name'] = user.firstName
    ..fields['middle_name'] = user.middleName
    ..fields['last_name'] = user.lastName
    ..fields['phone_number'] = user.phoneNumber
    ..fields['phone_country_code'] = user.phoneCountryCode
    ..fields['email'] = user.emailId;

  try {
    // Send the request and get the response
    final streamedResponse = await payload.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('status') && jsonData['status'] == true) {
        // Successfully added user
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

  // Prepare the JSON payload
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
    // Send the PUT request with JSON body
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('status') && jsonData['status'] == true) {
        // Successfully updated user
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

class Trial1 extends StatefulWidget {
  const Trial1({super.key});

  @override
  _Trial1State createState() => _Trial1State();
}

class _Trial1State extends State<Trial1> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers(); // Fetch users initially
  }

  void _refreshUsers() {
    if (mounted) {
      setState(() {
        _usersFuture = fetchUsers(); // Re-fetch users
      });
    }
  }

  Future<void> _deleteUser(User user) async {
    try {
      await deleteUser(user.registrationMainID);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      _refreshUsers(); // Refresh the user list after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  void _updateUser(User user) {
    // Show a dialog to update user details
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final phoneNumberController = TextEditingController(text: user.phoneNumber);
    final emailController = TextEditingController(text: user.emailId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await updateUser(User(
                    registrationMainID: user.registrationMainID,
                    userCode: user.userCode,
                    firstName: firstNameController.text,
                    middleName: user.middleName,
                    lastName: lastNameController.text,
                    phoneNumber: phoneNumberController.text,
                    phoneCountryCode: user.phoneCountryCode,
                    emailId: emailController.text,
                  ));
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User updated successfully')),
                  );
                  _refreshUsers(); // Refresh the user list after update
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update user: $e')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the dialog box to add a user
          final userCodeController = TextEditingController();
          final firstNameController = TextEditingController();
          final middleNameController = TextEditingController();
          final lastNameController = TextEditingController();
          final phoneNumberController = TextEditingController();
          final phoneCountryCodeController = TextEditingController();
          final emailController = TextEditingController();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add User'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: userCodeController,
                        decoration: const InputDecoration(labelText: 'User Code'),
                      ),
                      TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(labelText: 'First Name'),
                      ),
                      TextField(
                        controller: middleNameController,
                        decoration: const InputDecoration(labelText: 'Middle Name'),
                      ),
                      TextField(
                        controller: lastNameController,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                      ),
                      TextField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                      ),
                      TextField(
                        controller: phoneCountryCodeController,
                        decoration: const InputDecoration(labelText: 'Phone Country Code'),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(), // Close the dialog
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        // Create a new User object
                        final newUser = User(
                          userCode: userCodeController.text,
                          firstName: firstNameController.text,
                          middleName: middleNameController.text,
                          lastName: lastNameController.text,
                          phoneNumber: phoneNumberController.text,
                          phoneCountryCode: phoneCountryCodeController.text,
                          emailId: emailController.text,
                          registrationMainID: '', // This can be generated by the server
                        );

                        // Call the addUser function
                        await addUser(newUser);

                        Navigator.of(context).pop(); // Close the dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User added successfully')),
                        );
                        _refreshUsers(); // Refresh the user list
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add user: $e')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Trial 1'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsers, // Call the refresh function
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<User>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final List<User> admissions = snapshot.data!;
              if (admissions.isEmpty) {
                return const Text('No users found.');
              }
              return ListView.builder(
                itemCount: admissions.length,
                itemBuilder: (context, index) {
                  final admission = admissions[index];
                  return Dismissible(
                    key: Key(admission.registrationMainID), // Unique key for each item
                    direction: DismissDirection.horizontal, // Allow swiping left and right
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        // Swiped right (trigger update)
                        _updateUser(admission);
                      } else if (direction == DismissDirection.endToStart) {
                        // Swiped left (trigger delete)
                        _deleteUser(admission);
                      }
                    },
                    background: Container(
                      color: Colors.blue, // Background for swipe right (update)
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red, // Background for swipe left (delete)
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: UserCard(
                      user: admission,
                    ),
                  );
                },
              );
            } else {
              return const Text('No data received.');
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Trial1(),
   ));
}
