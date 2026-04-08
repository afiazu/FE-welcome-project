import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:go_router/go_router.dart';

class Desktopsidebar extends StatefulWidget {
  const Desktopsidebar({super.key});

  @override
  State<Desktopsidebar> createState() => _DesktopsidebarState();
}

class _DesktopsidebarState extends State<Desktopsidebar> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isHovered ? 300 : 70, 
        decoration: BoxDecoration(
          color: isHovered ? Colors.grey[100] : Colors.grey[100],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Center(
                child: Image.asset(
                  ImageConstants.UBTSlogo,
                  height: isHovered ? 80 : 40,
                  width: isHovered ? 80 : 40,
                ),
              ),
            ),
            
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Navigation Items
            _sideItem(Icons.home, 'DASHBOARD', '/dashboard'),
            _sideItem(Icons.inventory, 'INVENTORY', '/inventory'),
            _sideItem(Icons.person, 'PROFILE', '/profile'),

            const Spacer(), // Logout at the bottom

            _sideItem(Icons.logout, 'LOGOUT', '/login'),
          ],
        ),
      ),
    );
  }

  Widget _sideItem(IconData icon, String label, String route) { 
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          context.go(route);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 50,
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Icon(icon, color: Colors.blueGrey[800]),
              ),
              if (isHovered)
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}