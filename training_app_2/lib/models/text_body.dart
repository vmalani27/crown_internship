import 'package:flutter/foundation.dart';

class TextBody {
  final String userId;
  final String id;
  final String title;
  final String body;


  TextBody({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory TextBody.fromJson(Map<String, dynamic> json) {
    return TextBody(
      userId: json['userId'].toString(),
      id: json['id'].toString(),
      title: json['title'],
      body: json['body'],
    );
  }
}