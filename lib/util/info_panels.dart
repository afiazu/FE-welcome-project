import 'package:flutter/material.dart';
import '../model/low_stock_item.dart';
import '../model/category.dart';
import '../view/screens/inventory.dart'; 
import 'package:go_router/go_router.dart';

class LowStockPanel extends StatelessWidget {
  final List<LowStockItem> lowStockItems;

  const LowStockPanel({super.key, required this.lowStockItems});

  @override
  Widget build(BuildContext context) {
    if (lowStockItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle,
        color: Colors.green,
        title: 'No Low Stock Items',
        subtitle: 'All inventory levels are good!',
      );
    }

    return _buildItemGrid(
      context: context,
      icon: Icons.warning,
      color: Colors.orange,
      title: 'Low Stock Items',
      items: lowStockItems,
      showQuantity: true,
    );
  }
}

class DiscontinuedPanel extends StatelessWidget {
  final List<LowStockItem> discontinuedItems;

  const DiscontinuedPanel({super.key, required this.discontinuedItems});

  @override
  Widget build(BuildContext context) {
    if (discontinuedItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle,
        color: Colors.green,
        title: 'No Discontinued Items',
        subtitle: 'All items are active!',
      );
    }

    return _buildItemGrid(
      context: context,
      icon: Icons.cancel,
      color: Colors.red,
      title: 'Discontinued Items',
      items: discontinuedItems,
      showQuantity: false,
    );
  }
}

class CategoriesPanel extends StatelessWidget {
  final List<Category> categories;

  const CategoriesPanel({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _buildEmptyState(
        icon: Icons.category,
        color: Colors.purple,
        title: 'No Categories',
        subtitle: 'No categories found!',
      );
    }

    return _buildCategoryGrid(
      context: context,
      icon: Icons.category,
      color: Colors.purple,
      title: 'Categories',
      categories: categories,
    );
  }
}

Widget _buildItemGrid({
  required BuildContext context,
  required IconData icon,
  required Color color,
  required String title,
  required List<LowStockItem> items,
  required bool showQuantity,
}) {
  final bool isMobile = MediaQuery.of(context).size.width < 600;
  
  // Limit the number of items shown
  final displayItems = items.take(4).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildHeader(icon, color, "$title (${items.length})"),
      const SizedBox(height: 8),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          final item = displayItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _buildCompactItemCard(item, showQuantity, color),
          );
        },
      ),
      if (items.length > 4)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "+ ${items.length - 4} more items",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ],
  );
}

Widget _buildCategoryGrid({
  required BuildContext context,
  required IconData icon,
  required Color color,
  required String title,
  required List<Category> categories,
}) {
  final bool isMobile = MediaQuery.of(context).size.width < 600;
  
  // Limit the number of categories shown
  final displayCategories = categories.take(6).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeader(icon, color, "$title (${categories.length})"),
          // view all button
          TextButton(
            onPressed: () {
              // go to inventory page
            context.go('/inventory');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: displayCategories.map((category) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 6),
                Text(
                  category.categoryName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      if (categories.length > 6)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "+ ${categories.length - 6} more categories",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ],
  );
}

Widget _buildCompactItemCard(LowStockItem item, bool showQuantity, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300, width: 0.5),
    ),
    child: Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "Supplier :   ${item.supplierName}",
                style: const TextStyle(fontSize: 11, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Inventory Location :   ${item.location}",
                style: const TextStyle(fontSize: 11, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              if (showQuantity) // Only show quantity for low stock items
                Text(
                  "Quantity left :   ${item.quantity}",
                  style: const TextStyle(fontSize: 11, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildHeader(IconData icon, Color color, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    ),
  );
}

Widget _buildEmptyState({
  required IconData icon,
  required Color color,
  required String title,
  required String subtitle,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}