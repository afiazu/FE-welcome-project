import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:welcome_project_fe/model/user.dart';
import '../model/supplier.dart';
import '../model/low_stock_item.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000';
  
  static Future<List<Supplier>> getAllSuppliers() async {
    final url = Uri.parse('$_baseUrl/suppliers');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Supplier.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load suppliers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching suppliers: $e');
      return [];
    }
  }

  static Future<List<Supplier>> searchSuppliers(String searchQuery) async {
    final url = Uri.parse('$_baseUrl/suppliers/search?search=$searchQuery');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Supplier.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error searching suppliers: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final url = Uri.parse('$_baseUrl/dashboard/stats');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'totalItems': 0,
          'lowStock': 0,
          'checkedOut': 0,
          'categories': 0,
        };
      }
    } catch (e) {
      return {
        'totalItems': 0,
        'lowStock': 0,
        'checkedOut': 0,
        'categories': 0,
      };
    }
  }

  static Future<List<LowStockItem>> getLowStockItems({int threshold = 10}) async {
    final url = Uri.parse('$_baseUrl/inventory/low-stock?threshold=$threshold');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => LowStockItem.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getAllInventoryItems() async {
    final url = Uri.parse('$_baseUrl/inventory');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch inventory: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching inventory: $e');
    }
  }

  static Future<List<dynamic>> getInventoryByCategoryID(int categoryId) async {
    final url = Uri.parse('$_baseUrl/inventory/category/$categoryId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch category items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category items: $e');
    }
  }

  static Future<List<dynamic>> searchInventoryByName(String name) async {
    final url = Uri.parse(
        '$_baseUrl/inventory/search?name=${Uri.encodeComponent(name)}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching inventory: $e');
    }
  }

  static Future<List<dynamic>> getAllCategories() async {
    final url = Uri.parse('$_baseUrl/categories');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/users'); // Consider updating route to /login
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        throw error;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<UserModel> getUserById(String userId) async {
    final url = Uri.parse('$_baseUrl/users/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  static Future<void> updateUserInfo(String userId, String username, String email) async {
    final url = Uri.parse('$_baseUrl/users/$userId');
    final body = jsonEncode({'user_name': username, 'user_email': email});

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
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
    final url = Uri.parse('$_baseUrl/users/$userId/password');

    final body = jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return;
      }

      final errorText = response.body.isNotEmpty
          ? jsonDecode(response.body)['error'] ?? 'Failed to change password'
          : 'Unknown error';

      throw errorText;
    } catch (e) {
      throw e.toString();
    }
  }
}