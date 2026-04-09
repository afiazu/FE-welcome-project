import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/view/screens/inventory.dart';
import '../../util/welcomeSection.dart';
import '../../util/dashboardBox.dart';
import '../../util/info_panels.dart';
import '../../model/supplier.dart';
import '../../api_service.dart';
import 'package:welcome_project_fe/util/MobileSideBar.dart';
import 'package:welcome_project_fe/util/DesktopSideBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../model/low_stock_item.dart';
import '../../model/category.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.userId});
  final int? userId;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCard = "Low Stock";

  bool _isLoading = true;
  bool _isLoadingUser = true;

  String? _errorMessage;
  String _username = "Guest";

  List<Supplier> _suppliers = [];
  List<Supplier> _filteredSuppliers = [];

  Map<String, dynamic> _dashboardStats = {};

  List<LowStockItem> _lowStockItems = [];
  List<LowStockItem> _discontinuedItems = [];
  List<Category> _categories = [];

  String _searchQuery = "";
  bool _showAllSuppliers = false;

  int _initialDisplayCount = 6;

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
    try {
      final prefs = await SharedPreferences.getInstance();

      String? savedUsername = prefs.getString('username');

      if (savedUsername != null) {
        setState(() {
          _username = savedUsername;
          _isLoadingUser = false;
        });
        return;
      }

      if (widget.userId == null) {
        setState(() {
          _isLoadingUser = false;
        });
        return;
      }

      final user = await ApiService.getUserById(widget.userId.toString());

      await prefs.setString('username', user.username);

      setState(() {
        _username = user.username;
        _isLoadingUser = false;
      });
    } catch (e) {
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
    } catch (_) {}
  }

  Future<void> _fetchDiscontinuedItems() async {
    try {
      final items = await ApiService.getDiscontinuedItems();
      setState(() {
        _discontinuedItems = items;
      });
    } catch (_) {}
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (_) {}
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
        _filteredSuppliers = _suppliers;
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

    setState(() {
      _searchQuery = "";
      _filteredSuppliers = _suppliers;
      _showAllSuppliers = false;
    });
  }

  void _searchSuppliers(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _filteredSuppliers = _suppliers;
      } else {
        _filteredSuppliers = _suppliers.where((supplier) {
          return supplier.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktop = screenWidth >= 800;
    final bool isMobile = screenWidth < 600;

    int displayedSuppliers = _showAllSuppliers
        ? _filteredSuppliers.length
        : _initialDisplayCount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.ubtsBlue,
        automaticallyImplyLeading: !isDesktop,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      drawer: isDesktop ? null : const Mobilesidebar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: isDesktop ? 70 : 0),
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoadingUser
                          ? const LinearProgressIndicator()
                          : WelcomeSection(userName: _username),

                      const SizedBox(height: 16),

                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildStatsGrid(isMobile),

                      const SizedBox(height: 24),

                      _buildRightPanel(),

                      const SizedBox(height: 24),

                      _buildSupplierSection(displayedSuppliers),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isDesktop)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Desktopsidebar(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: isMobile ? 1.2 : 1.6,
      children: [
        DashboardBox(
          title: 'Total Items',
          value: _dashboardStats['totalItems']?.toString() ?? '0',
          icon: Icons.inventory,
          iconColor: Colors.blue,
          onTap: () {
            context.go('/inventory');
          }
        ),
        DashboardBox(
          title: 'Low Stock',
          value: _dashboardStats['lowStock']?.toString() ?? '0',
          icon: Icons.warning,
          iconColor: Colors.orange,
          onTap: () => _updatePanel('Low Stock'),
        ),
        DashboardBox(
          title: 'Discontinued',
          value: _discontinuedItems.length.toString(),
          icon: Icons.cancel,
          iconColor: Colors.red,
          onTap: () => _updatePanel('Discontinued'),
        ),
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

  Widget _buildSupplierSection(int displayedSuppliers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search suppliers...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: _searchSuppliers,
        ),

        const SizedBox(height: 12),

        _buildSupplierGrid(displayedSuppliers),

        if (_filteredSuppliers.length > _initialDisplayCount)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showAllSuppliers = !_showAllSuppliers;
                  });
                },
                icon: Icon(
                  _showAllSuppliers
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                label: Text(
                  _showAllSuppliers
                      ? "Show Less"
                      : "Show More (${_filteredSuppliers.length - _initialDisplayCount})",
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSupplierGrid(int itemCount) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;

    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount > _filteredSuppliers.length
          ? _filteredSuppliers.length
          : itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final supplier = _filteredSuppliers[index];
        return _buildSupplierCard(supplier);
      },
    );
  }

  Widget _buildSupplierCard(Supplier supplier) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplier.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Phone: ${supplier.phone}",
              style: const TextStyle(fontSize: 11),
            ),
            Text(
              "Email: ${supplier.email}",
              style: const TextStyle(fontSize: 11),
            ),
            Text(
              "Address: ${supplier.address}",
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePanel(String title) {
    setState(() {
      selectedCard = title;
    });
  }

  Widget _buildRightPanel() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 400, // Limit the height of the right panel
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(child: _getPanelContent()),
        ),
      ),
    );
  }

  Widget _getPanelContent() {
    switch (selectedCard) {
      case 'Low Stock':
        return LowStockPanel(lowStockItems: _lowStockItems);
      case 'Discontinued':
        return DiscontinuedPanel(discontinuedItems: _discontinuedItems);
      case 'Categories':
        return CategoriesPanel(categories: _categories);
      default:
        return LowStockPanel(lowStockItems: _lowStockItems);
    }
  }
}
