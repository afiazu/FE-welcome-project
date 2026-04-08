import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/view/screens/inventory.dart';
import '../../util/welcomeSection.dart';
import '../../util/dashboardBox.dart';
import '../../util/supplier_carousel.dart';
import '../../util/info_panels.dart';
import '../../model/supplier.dart';
import '../../model/low_stock_item.dart';
import '../../model/category.dart';
import '../../api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.userId});
  final int? userId;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCard = "Total Items";
  bool _isLoading = true;
  String? _errorMessage;
  bool _isLoadingUser = true;
  String _username = 'Guest';
  
  List<Supplier> _suppliers = [];
  Map<String, dynamic> _dashboardStats = {};
  List<LowStockItem> _lowStockItems = [];
  List<LowStockItem> _discontinuedItems = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchUsername();
    _fetchLowStockItems();
    _fetchDiscontinuedItems();
    _fetchCategories();
  }

  Future<void> _fetchUsername() async {
    if (widget.userId == null) {
      setState(() {
        _isLoadingUser = false;
      });
      return;
    }
    
    try {
      final user = await ApiService.getUserById(widget.userId.toString());
      setState(() {
        _username = user.username;
        _isLoadingUser = false;
      });
    } catch (e) {
      print('Error fetching username: $e');
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _fetchLowStockItems() async {
    try {
      final items = await ApiService.getLowStockItems();
      setState(() {
        _lowStockItems = items;
      });
    } catch (e) {
      print('Error fetching low stock items: $e');
    }
  }

  Future<void> _fetchDiscontinuedItems() async {
    try {
      final items = await ApiService.getDiscontinuedItems();
      setState(() {
        _discontinuedItems = items;
      });
    } catch (e) {
      print('Error fetching discontinued items: $e');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
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
      ]);

      setState(() {
        _suppliers = results[0] as List<Supplier>;
        _dashboardStats = results[1] as Map<String, dynamic>;
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
    await _fetchUsername();
    await _fetchLowStockItems();
    await _fetchDiscontinuedItems();
    await _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.grey[100], 
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard Overview',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 28,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.ubtsBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Track your inventory and supplier metrics',
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isLoadingUser
                            ? const SizedBox(
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : WelcomeSection(userName: _username),
                      ],
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Responsive Dashboard Boxes - 2x2 on mobile, 1x4 on desktop
                    _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : isMobile 
                          ? _buildMobileDashboardBoxes()
                          : _buildDesktopDashboardBoxes(),

                    const SizedBox(height: 30),

                    // Responsive layout for Supplier Carousel and Right Panel
                    isMobile
                        ? _buildMobileLayout()
                        : _buildDesktopLayout(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Desktop: 4 boxes in a row
  Widget _buildDesktopDashboardBoxes() {
    return Row(
      children: [
        DashboardBox(
          title: 'Total Items',
          value: _dashboardStats['totalItems']?.toString() ?? '0',
          icon: Icons.inventory,
          iconColor: Colors.blue,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryScreen()));
          },
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
          title: 'Discontinued',
          value: _discontinuedItems.length.toString(),
          icon: Icons.cancel,
          iconColor: Colors.red,
          onTap: () => _updatePanel('Discontinued'),
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

  // Mobile: 2x2 grid for boxes
  Widget _buildMobileDashboardBoxes() {
    return Column(
      children: [
        Row(
          children: [
            DashboardBox(
              title: 'Total Items',
              value: _dashboardStats['totalItems']?.toString() ?? '0',
              icon: Icons.inventory,
              iconColor: Colors.blue,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryScreen()));
              },
            ),
            const SizedBox(width: 12),
            DashboardBox(
              title: 'Low Stock',
              value: _dashboardStats['lowStock']?.toString() ?? '0',
              icon: Icons.warning,
              iconColor: Colors.orange,
              onTap: () => _updatePanel('Low Stock'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            DashboardBox(
              title: 'Discontinued',
              value: _discontinuedItems.length.toString(),
              icon: Icons.cancel,
              iconColor: Colors.red,
              onTap: () => _updatePanel('Discontinued'),
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
        ),
      ],
    );
  }

  // Desktop: Supplier Carousel on left, Right Panel on right
  Widget _buildDesktopLayout() {
    return SizedBox(
      height: 260,
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
    );
  }

  // Mobile: Supplier Carousel on top, Right Panel below
  Widget _buildMobileLayout() {
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: _buildSupplierSection(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: _buildRightPanel(),
        ),
      ],
    );
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
        return LowStockPanel(lowStockItems: _lowStockItems);

      case 'Discontinued':
        return DiscontinuedPanel(discontinuedItems: _discontinuedItems);

      case 'Categories':
        return CategoriesPanel(categories: _categories);

      default:
        return _infoBox(
          "Total Items",
          "${_dashboardStats['totalItems'] ?? 0} items in inventory"
        );
    }
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