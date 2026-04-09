import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:go_router/go_router.dart';
import 'package:welcome_project_fe/api_service.dart';

class Mobilesidebar extends StatefulWidget {
  const Mobilesidebar({super.key});

  @override
  State<Mobilesidebar> createState() => _MobilesidebarState();
}

class _MobilesidebarState extends State<Mobilesidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, 
      ),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Center(
              child: Image.asset(
                ImageConstants.UBTSlogo,
                height: 80, 
                width: 80,
              ),
            ),
          ),
          
          const Divider(height: 1),
          const SizedBox(height: 10),

          _buildMobileNavItem(Icons.home, 'DASHBOARD', onTap: () => context.go('/dashboard')),
          _buildMobileNavItem(Icons.inventory, 'INVENTORY', onTap: () => context.go('/inventory')),
          _buildMobileNavItem(Icons.person, 'PROFILE', onTap: () => context.go('/profile')),

          const Spacer(), // Logout at the bottom

          _buildMobileNavItem(Icons.logout, 'LOGOUT', onTap: () => ApiService.logout(context)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMobileNavItem(IconData icon, String label, {required VoidCallback onTap}) { 
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey[800]),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        onTap: onTap
      ),
    );
  }
}