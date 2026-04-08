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
  } catch (e) {
    print('❌ Error fetching low stock items: $e');
    return [];
  }
}
}