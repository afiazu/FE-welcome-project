import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:go_router/go_router.dart';

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
      child: Column(
        children: [
          // Styled Header to match Desktop
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

          _buildMobileNavItem(Icons.home, 'DASHBOARD', '/dashboard'),
          _buildMobileNavItem(Icons.inventory, 'INVENTORY', '/inventory'),
          _buildMobileNavItem(Icons.person, 'PROFILE', '/profile'),

          const Spacer(), // Logout at the bottom

          _buildMobileNavItem(Icons.logout, 'LOGOUT', '/login'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMobileNavItem(IconData icon, String label, String route) { 
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () {
          Navigator.pop(context); 
          context.go(route);
        },
      ),
    );
  }
}