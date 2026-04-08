import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import '../../util/welcomeSection.dart';
import '../../util/dashboardBox.dart';
import '../../util/supplier_carousel.dart';
import '../../model/supplier.dart';
import '../../api_service.dart';
import '../../model/low_stock_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCard = "Total Items";
  
  bool _isLoading = true;
  String? _errorMessage;
  
  List<Supplier> _suppliers = [];
  Map<String, dynamic> _dashboardStats = {};
  List<LowStockItem> _lowStockItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        ApiService.getAllSuppliers(),
        ApiService.getDashboardStats(),
        ApiService.getLowStockItems(),
      ]);

      setState(() {
        _suppliers = results[0] as List<Supplier>;
        _dashboardStats = results[1] as Map<String, dynamic>;
        _lowStockItems = results[2] as List<LowStockItem>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.ubtsBlue,
        title: Text(
          'User Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const WelcomeSection(),
              const SizedBox(height: 30),

              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _buildDashboardBoxes(),

              const SizedBox(height: 30),

              SizedBox(
                height: 400, // Increased height for better display
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSupplierSection(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRightPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardBoxes() {
    return Row(
      children: [
        DashboardBox(
          title: 'Total Items',
          value: _formatNumber(_dashboardStats['totalItems'] ?? 0),
          icon: Icons.inventory,
          iconColor: Colors.blue,
          onTap: () => _updatePanel('Total Items'),
        ),
        const SizedBox(width: 12),
        DashboardBox(
          title: 'Low Stock',
          value: _dashboardStats['lowStock']?.toString() ?? '0',
          icon: Icons.warning,
          iconColor: Colors.orange,
          onTap: () => _updatePanel('Low Stock'),
        ),
        const SizedBox(width: 12),
        DashboardBox(
          title: 'Checked Out',
          value: _dashboardStats['checkedOut']?.toString() ?? '0',
          icon: Icons.exit_to_app,
          iconColor: Colors.green,
          onTap: () => _updatePanel('Checked Out'),
        ),
        const SizedBox(width: 12),
        DashboardBox(
          title: 'Categories',
          value: _dashboardStats['categories']?.toString() ?? '0',
          icon: Icons.category,
          iconColor: Colors.purple,
          onTap: () => _updatePanel('Categories'),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildSupplierSection() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text('Error: $_errorMessage'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_suppliers.isEmpty) {
      return const Center(
        child: Text('No suppliers found'),
      );
    }

    return SupplierCarousel(
      suppliers: _suppliers,
    );
  }

  void _updatePanel(String title) {
    setState(() {
      selectedCard = title;
    });
  }

  Widget _buildRightPanel() {
    switch (selectedCard) {
      case 'Low Stock':
        return _buildLowStockPanel();

      case 'Checked Out':
        return _infoBox(
          "Checked Out Items",
          "${_dashboardStats['checkedOut'] ?? 0} items currently borrowed"
        );

      case 'Categories':
        return _infoBox(
          "Categories",
          "Total of ${_dashboardStats['categories'] ?? 0} categories available"
        );

      default:
        return _infoBox(
          "Total Inventory",
          "${_formatNumber(_dashboardStats['totalItems'] ?? 0)} total items in inventory"
        );
    }
  }

  Widget _buildLowStockPanel() {
    if (_lowStockItems.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 48, color: Colors.green),
              const SizedBox(height: 8),
              const Text(
                'No Low Stock Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'All inventory levels are good!',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Low Stock Items (${_lowStockItems.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          
          // List of low stock items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _lowStockItems.length,
              separatorBuilder: (context, index) => const Divider(height: 12),
              itemBuilder: (context, index) {
                final item = _lowStockItems[index];
                return _buildLowStockCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockCard(LowStockItem item) {
    Color quantityColor;
    String quantityStatus;
    if (item.quantity <= 0) {
      quantityColor = Colors.red;
      quantityStatus = 'OUT OF STOCK';
    } else if (item.quantity <= 5) {
      quantityColor = Colors.yellow;
      quantityStatus = 'CRITICAL';
    } else {
      quantityColor = Colors.orange;
      quantityStatus = 'LOW STOCK';
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            _showItemDetails(item);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item name and quantity status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: quantityColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory, size: 12, color: quantityColor),
                          const SizedBox(width: 4),
                          Text(
                            '${item.quantity} left',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: quantityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    quantityStatus,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: quantityColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                // supplier name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.business, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Supplier',
                            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                          ),
                          Text(
                            item.supplierName,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Category
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.category, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                          ),
                          Text(
                            item.categoryName,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                          ),
                          Text(
                            item.location,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // remind for low stock
                if (item.quantity <= 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red[700]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Restock immediately! Only ${item.quantity} items remaining.',
                              style: TextStyle(fontSize: 11, color: Colors.red[700], fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showItemDetails(LowStockItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(child: Text(item.name)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Current Quantity', '${item.quantity} units'),
              const Divider(),
              _buildDetailRow('Supplier', item.supplierName),
              const Divider(),
              _buildDetailRow('Category', item.categoryName),
              const Divider(),
              _buildDetailRow('Location', item.location),
              const Divider(),
              if (item.quantity <= 5)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'This item needs immediate restocking!',
                    style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Add restock functionality here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Restock feature coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Restock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String title, String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(content),
          ],
        ),
      ),
    );
  }
}