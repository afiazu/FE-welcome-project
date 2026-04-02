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


class ApiService {
  static const String _baseUrl =  'http://localhost:3000';

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
}