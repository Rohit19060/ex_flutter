import 'dart:convert';

import 'package:http/http.dart';

class UserRepository {
  UserRepository(this.client);
  final Client client;

  Future<User> getUser() async {
    final res = await client.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));
    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user');
    }
  }
}

class User {
  User({required this.name, required this.email, required this.phone, required this.website});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'].toString(),
        email: json['email'].toString(),
        phone: json['phone'].toString(),
        website: json['website'].toString(),
      );
  final String name, email, phone, website;
}
