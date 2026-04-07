/* 
this is the file where you will write your API calls to the backend. 
you can use the http package to make requests and handle responses. 
make sure to handle errors and edge cases appropriately.
*/

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:welcome_project_fe/model/user.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000';

  static Future<Map<String, dynamic>> healthCheck() async {
    final url = Uri.parse('$_baseUrl/health');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to connect: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }

  static Future<UserModel> getUserById(String userId) async {
    final url = Uri.parse('$_baseUrl/users/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  }

  static Future<void> updateUserInfo(
    String userId,
    String username,
    String email,
  ) async {
    final url = Uri.parse('$_baseUrl/users/$userId');
    final body = jsonEncode({'user_name': username, 'user_email': email});

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  static Future<void> updateUserPassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    // Note: Ensure this URL matches your backend route exactly
    final url = Uri.parse('$_baseUrl/users/$userId/password');

    final body = jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return;
    }

    final errorText = response.body.isNotEmpty
        ? jsonDecode(response.body)['error'] ?? response.body
        : 'Unknown error';

    throw 'Failed to change password (${response.statusCode}): $errorText';
  }
}
