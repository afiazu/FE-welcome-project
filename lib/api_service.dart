import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:welcome_project_fe/model/activity.dart';
import 'package:welcome_project_fe/model/inventory.dart';
import 'package:welcome_project_fe/model/user.dart';
import '../model/supplier.dart';
import '../model/low_stock_item.dart';
import 'model/category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

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
      print('Error fetching low stock items: $e');
      return [];
    }
  }
    static Future<List<Inventory>> getAllInventoryItems() async {
      final url = Uri.parse('$_baseUrl/inventory');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          return body.map((json) => Inventory.fromJson(json)).toList();
        } else {
          return [];
        }
      } catch (e) {
        print('Error fetching all inventory items: $e');
        return [];
      }
    }

  static Future<List<Inventory>> getInventoryByCategoryID(int categoryId) async {
    final url = Uri.parse('$_baseUrl/inventory/category/$categoryId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Inventory.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching inventory by category: $e');
      return [];
    }
  }

  static Future<List<Inventory>> searchInventoryByName(String name) async {
    final url = Uri.parse('$_baseUrl/inventory/search?name=$name');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Inventory.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error searching inventory: $e');
      return [];
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

  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_baseUrl/categories');
    print('Fetching categories from: $url');
    
    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        print('Found ${body.length} categories');
        return body.map((json) => Category.fromJson(json)).toList();
      } else {
        print('Failed to fetch categories');
        return [];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/users'); 
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

  static Future<void> updateUserInfo(String userId, String username, String email, String profileImageUrl, String userBio) async {
    final url = Uri.parse('$_baseUrl/users/$userId');
    final body = jsonEncode({'user_name': username, 'user_email': email, 'user_profileImageUrl': profileImageUrl, 'user_bio': userBio});

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

  static Future<List<LowStockItem>> getDiscontinuedItems() async {
    final url = Uri.parse('$_baseUrl/inventory/discontinued');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => LowStockItem.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching discontinued items: $e');
      return [];
    }
  }

  static Future<List<ActivityModel>> getActivitiesByUserId(String userId) async {
    final url = Uri.parse('$_baseUrl/activities/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body is List) {
          return body.map((json) => ActivityModel.fromJson(json)).toList();
        } else if (body is Map<String, dynamic>) {
          // If it's a single activity, wrap in list
          return [ActivityModel.fromJson(body)];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Activities not found');
      }
    } catch (e) {
      throw Exception('Failed to load activity data: $e');
    }
  }
  
  static Future<List<Inventory>> getActiveItems() async {
  final url = Uri.parse('$_baseUrl/inventory/active');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Inventory.fromJson(json)).toList();
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching active items: $e');
    return [];
  }
}

static Future<List<Inventory>> getArchivedItems() async {
  final url = Uri.parse('$_baseUrl/inventory/archived');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Inventory.fromJson(json)).toList();
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching archived items: $e');
    return [];
  }
}


  static Future<Map<String, dynamic>> register(String username,String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/register'); 
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        final String errorMessage = errorBody['error'] ?? 'Registration failed';
        throw errorMessage; 
      }
    } catch (e) {
      throw e.toString();
    }
  } 

  static Future<void> logout(BuildContext context) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      
      await preferences.clear();

      // Back to Login Screen
      if (context.mounted) {
        context.go('/login');
      }
      
    } catch (e) {
      print('Error during logout: $e');
    }
  }

}