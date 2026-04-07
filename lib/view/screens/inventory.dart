import 'package:flutter/material.dart';
import 'inventory_desktop.dart';
import 'inventory_mobile.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 768) {
      return const InventoryMobile();
    } else {
      return const InventoryDesktop();
    }
  }
}