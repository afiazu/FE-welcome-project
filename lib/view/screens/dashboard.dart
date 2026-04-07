import 'package:flutter/material.dart';
import '../../util/welcomeSection.dart';
import '../../util/dashboardBox.dart';
import '../../util/supplier_table.dart';
import '../../model/supplier.dart'; 

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

//hardcode data
  final List<Supplier> _sampleSuppliers = [
    Supplier(
      id: 1,
      name: 'Tech Supplies Co',
      phone: '+65123456789',
      email: 'contact@techsupplies.com',
      address: 'edxcfrtgfvgh road',
      createdAt: '2024-01-15',
    ),
    Supplier(
      id: 2,
      name: 'Office Depot',
      phone: '+65123456790',
      email: 'sales@officedepot.com',
      address: 'xcvbnm road',
      createdAt: '2024-02-20',
    ),
    Supplier(
      id: 3,
      name: 'ElectroMart',
      phone: '+65123456791',
      email: 'info@electromart.com',
      address: 'wertyui road',
      createdAt: '2024-03-10',
    ),
    Supplier(
      id: 4,
      name: 'Furniture World',
      phone: '+65123456792',
      email: 'orders@furnitureworld.com',
      address: 'ertyu road',
      createdAt: '2024-03-25',
    ),
    Supplier(
      id: 5,
      name: 'Logistics Plus',
      phone: '+65123456793',
      email: 'support@logisticsplus.com',
      address: 'bwjhcbw road',
      createdAt: '2024-04-01',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeSection(),
            const SizedBox(height: 30),
            
            Row(
              children: [
                DashboardBox(
                  title: 'Total Items',
                  value: '1,234',
                  icon: Icons.inventory,
                ),
                const SizedBox(width: 16),
                DashboardBox(
                  title: 'Low Stock',
                  value: '12',
                  icon: Icons.warning,
                ),
                const SizedBox(width: 16),
                DashboardBox(
                  title: 'Checked Out',
                  value: '23',
                  icon: Icons.exit_to_app,
                ),
                const SizedBox(width: 16),
                DashboardBox(
                  title: 'Categories',
                  value: '8',
                  icon: Icons.category,
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            SupplierTable(
              suppliers: _sampleSuppliers,
            ),
          ],
        ),
      ),
    );
  }
}