import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/supplier.dart';
import '../model/low_stock_item.dart'; // Add this import

class ApiService {
  static const String _baseUrl = 'http://localhost:3000';
  
  // Supplier endpoints
  static Future<List<Supplier>> getAllSuppliers() async {
    final url = Uri.parse('$_baseUrl/suppliers');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Supplier.fromJson(json)).toList();
      } else {
        print('Failed to load suppliers: ${response.statusCode}');
        return [];
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
        print('Failed to search suppliers: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error searching suppliers: $e');
      return [];
    }
  }

  // Dashboard endpoints
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final url = Uri.parse('$_baseUrl/dashboard/stats');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load stats: ${response.statusCode}');
        return {
          'totalItems': 0,
          'lowStock': 0,
          'checkedOut': 0,
          'categories': 0,
        };
      }
    } catch (e) {
      print('Error fetching stats: $e');
      return {
        'totalItems': 0,
        'lowStock': 0,
        'checkedOut': 0,
        'categories': 0,
      };
    }
  }

  // Get low stock items
  static Future<List<LowStockItem>> getLowStockItems({int threshold = 10}) async {
  final url = Uri.parse('$_baseUrl/inventory/low-stock?threshold=$threshold');
  print('📡 Fetching low stock from: $url');
  
  try {
    final response = await http.get(url);
    print('✅ Response status: ${response.statusCode}');
    print('📦 Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print('📊 Found ${body.length} low stock items');
      
      if (body.isEmpty) {
        print('⚠️ No low stock items found in database');
      }
      
      return body.map((json) => LowStockItem.fromJson(json)).toList();
    } else {
      print('❌ Failed to load low stock items: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('❌ Error fetching low stock items: $e');
    return [];
  }
}
}