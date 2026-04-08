import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import '../../util/welcomeSection.dart';
import '../../util/dashboardBox.dart';
import '../../util/supplier_carousel.dart';
import '../../model/supplier.dart';
import '../../api_service.dart'; 
import 'package:welcome_project_fe/util/MobileSideBar.dart';
import 'package:welcome_project_fe/util/DesktopSideBar.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCard = "Total Items";
  
  // Add loading and error states
  bool _isLoading = true;
  String? _errorMessage;
  
  // Real data from backend
  List<Supplier> _suppliers = [];
  Map<String, dynamic> _dashboardStats = {};

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
      // Fetch suppliers and stats in parallel
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
  }

@override
Widget build(BuildContext context) {
  bool isDesktop = MediaQuery.of(context).size.width >= 500;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: ColorConstants.ubtsBlue,
      automaticallyImplyLeading: !isDesktop,
      title: const Text(
        'User Dashboard',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    

    drawer: isDesktop ? null : const Mobilesidebar(),
      body: Stack(
        children: [
          // Main Content
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: isDesktop ? 70 : 0),
              child: RefreshIndicator(
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
                      ),
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

  Widget _buildDashboardBoxes() {
    return Row(
      children: [
        DashboardBox(
          title: 'Total Items',
          value: _dashboardStats['totalItems']?.toString() ?? '0',
          icon: Icons.inventory,
          iconColor: Colors.blue,
          onTap: () => _updatePanel('Total Items'),
        ),
        const SizedBox(width: 12),
        DashboardBox(
          title: 'Low Stock',
          value: _dashboardStats['lowStock']?.toString() ?? '0',
          icon: Icons.warning,
          iconColor: Colors.green,
          onTap: () => _updatePanel('Low Stock'),
        ),
        const SizedBox(width: 12),
        DashboardBox(
          title: 'Checked Out',
          value: _dashboardStats['checkedOut']?.toString() ?? '0',
          icon: Icons.exit_to_app,
          iconColor: Colors.yellow,
          onTap: () => _updatePanel('Checked Out'),
        ),
        const SizedBox(width: 12),
        DashboardBox(
          title: 'Categories',
          value: _dashboardStats['categories']?.toString() ?? '0',
          icon: Icons.category,
          iconColor: Colors.red,
          onTap: () => _updatePanel('Categories'),
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
        return _infoBox(
          "Low Stock",
          "${_dashboardStats['lowStock'] ?? 0} items are running low"
        );

      case 'Checked Out':
        return _infoBox(
          "Checked Out",
          "${_dashboardStats['checkedOut'] ?? 0} items currently borrowed"
        );

      case 'Categories':
        return _infoBox(
          "Categories",
          "${_dashboardStats['categories'] ?? 0} categories available"
        );

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