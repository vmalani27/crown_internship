class User {
  // Fields
  final String userCode;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;
  final String phoneCountryCode;
  final String emailId;
  final String registrationMainID;
  final String? createdTime; // Optional field

  // Parameterized Constructor
  User({
    required this.userCode,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phoneNumber,
    required this.phoneCountryCode,
    required this.emailId,
    required this.registrationMainID,
    this.createdTime, // Optional
  });

  // Factory Constructor for JSON Parsing
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      registrationMainID: json['registration_main_id'] ?? '',
      userCode: json['user_code'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      phoneCountryCode: json['phone_country_code'] ?? '',
      emailId: json['email'] ?? '',
      createdTime: json['created_time'], // Populated only from JSON
    );
  }

  // Method to Convert User Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'registration_main_id': registrationMainID,
      'user_code': userCode,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'phone_country_code': phoneCountryCode,
      'email': emailId,
      // 'created_time' is not included when sending data to the API
    };
  }
}