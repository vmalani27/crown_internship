import 'package:flutter/material.dart';
import 'package:training_app/api_helper/user_helper.dart';
import '../models/model.dart';
import 'package:training_app/widgets/card_view.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete user: $e')));
    }
  }

  void _updateUser(User user) {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final phoneNumberController = TextEditingController(text: user.phoneNumber);
    final emailController = TextEditingController(text: user.emailId);
    String phoneCountryCode = '+1'; // Default country code

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
                IntlPhoneField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  initialCountryCode: 'US', // Default country
                  onChanged: (phone) {
                    phoneCountryCode = phone.countryCode; // Update country code
                  },
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
                  await updateUser(
                    User(
                      registrationMainID: user.registrationMainID,
                      userCode: user.userCode,
                      firstName: firstNameController.text,
                      middleName: user.middleName,
                      lastName: lastNameController.text,
                      phoneNumber: phoneNumberController.text,
                      phoneCountryCode: phoneCountryCode,
                      emailId: emailController.text,
                    ),
                  );
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
          final userCodeController = TextEditingController();
          final firstNameController = TextEditingController();
          final middleNameController = TextEditingController();
          final lastNameController = TextEditingController();
          final phoneNumberController = TextEditingController();
          final emailController = TextEditingController();
          String phoneCountryCode = '+1'; // Default country code

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
                        decoration: const InputDecoration(
                          labelText: 'User Code',
                        ),
                      ),
                      TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                        ),
                      ),
                      TextField(
                        controller: middleNameController,
                        decoration: const InputDecoration(
                          labelText: 'Middle Name',
                        ),
                      ),
                      TextField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                        ),
                      ),
                      IntlPhoneField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        initialCountryCode: 'US', // Default country
                        onChanged: (phone) {
                          phoneCountryCode =
                              phone.countryCode; // Update country code
                        },
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        final newUser = User(
                          userCode: userCodeController.text,
                          firstName: firstNameController.text,
                          middleName: middleNameController.text,
                          lastName: lastNameController.text,
                          phoneNumber: phoneNumberController.text,
                          phoneCountryCode: phoneCountryCode,
                          emailId: emailController.text,
                          registrationMainID: '',
                        );

                        await addUser(newUser);

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User added successfully'),
                          ),
                        );
                        _refreshUsers();
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
        title: const Text('Home Page'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshUsers),
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
                    key: Key(admission.registrationMainID),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        _updateUser(admission);
                      } else if (direction == DismissDirection.endToStart) {
                        _deleteUser(admission);
                      }
                    },
                    background: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: UserCard(user: admission),
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
